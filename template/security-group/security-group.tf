#######################################
##     AWS Provider configuration    ##
#######################################
provider "aws" {
  region               = var.security_group_region_deployment
   assume_role {
    role_arn          = "arn:aws:iam::${local.account_id}:role/torque"

  }
  default_tags {
    tags = {
      Environment  = var.env
      Project      = var.project
    }
  }
}

provider "aws" {
  region                                      = "eu-west-1"
  alias                                       = "aws_alm"
}

data "aws_ssm_parameter" "torque-retrieve_the_vpcid_and_subnetid" {
  provider                = aws.aws_alm
  name                    = "torque-retrieve_the_vpcid_and_subnetid"
}

#***************************************************************************************
#  🍄  The algoritem to Retrieve the account id & VPC & SubnetID for deployment  🍄  **
#######################################################################################


locals { 
  # Splitting the multi-line parameter store value into a list of lines 
  accounts_objects_values = split("\n", data.aws_ssm_parameter.torque-retrieve_the_vpcid_and_subnetid.value) 
  
  # Finding the specific line that matches the account name 
  selected_account_values = [for line in local.accounts_objects_values : line if can(regex("${var.security_group_account_deployment}:.*:${var.security_group_region_deployment}.*", line))][0] 
  
  # Splitting the selected line into individual components 
  account_fields = split(":", local.selected_account_values) 
  
  
  account_name = local.account_fields[0] 
  account_id = local.account_fields[1] 
  vpc_id = local.account_fields[3] 
  subnet_ids_raw = trim(local.account_fields[4], "[]") 
  subnet_ids_list = split(",", replace(local.subnet_ids_raw, " ", "")) 
}

#############################################
##  🌳  Security Group configuration  🌳  ##
#############################################


#**************************************************
#  🍄  Retrieve the security group objects  🍄  **
#**************************************************

locals { 

  # Splitting the security group parameters into a list of lines 
  security_group_list = split(" ", var.security_group_objects) 
  
  # Parsing each line into security group components 
  security_group_objects = [ 
    for object in local.security_group_list : { 
	  name     = trimspace(element(split(":", object), 0))
	  protocol = trimspace(element(split(":", object), 1))
	  ports    = [for port in split(",", element(split(":", object), 2)) : tonumber(trimspace(port))]
       # tonumber(trimspace(replace(replace(port, "[", ""), "]", "")))
	  cidr     = trimspace(element(split(":", object), 3))
    } 
  ] 
}
  
#**************************************
#  🍄  Random string for names  🍄  **
#**************************************

resource "random_string" "resource_name" {
  length  = 8
  upper   = false
  special = false
  numeric = true
}


#**************************************
#  🍄 Security group Resources  🍄  ** 
#**************************************

resource "aws_security_group" "torque_resources" {
  #for_each                  = { for sg in local.security_group_objects : sg.name => sg }
  count                     = length(local.security_group_objects)
  #name                      = each.key
  name                      = "local.security_group_objects[count.index].name-${random_string.resource_name.result}"
  description               = "Security group attached to internet facing loadbalancer"
  vpc_id                    = local.vpc_id

  dynamic "ingress" {
    for_each                = local.security_group_objects[count.index].ports
    content {
      from_port             = ingress.value
      to_port               = ingress.value
      protocol              = local.security_group_objects[count.index].protocol
      cidr_blocks           = [local.security_group_objects[count.index].cidr]
    }
  }
  
  egress {
    description           = "Web Traffic from internet"
    from_port             = 0
    to_port               = 0
    protocol              = "-1"
    cidr_blocks           = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "security_group"
  }
}
