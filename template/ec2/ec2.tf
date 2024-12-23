###########################################
##  🌐  AWS Provider configuration  🌐  ##
###########################################

provider "aws" {
  region               = var.ec2_region_deployment
   assume_role {
    role_arn          = "arn:aws:iam::113834750184:role/torque-deployments"

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
#***************************************************************************************

locals { 
  # Splitting the multi-line parameter store value into a list of lines 
  accounts_objects_values = split("\n", data.aws_ssm_parameter.torque-retrieve_the_vpcid_and_subnetid.value) 
  
  # Finding the specific line that matches the account name 
  selected_account_values = [for line in local.accounts_objects_values : line if can(regex("${var.ec2_account_deployment}:.*:${var.ec2_region_deployment}.*", line))][0] 
  
  # Splitting the selected line into individual components 
  account_fields = split(":", local.selected_account_values) 
  
  
  account_name = local.account_fields[0] 
  account_id = local.account_fields[1] 
  vpc_id = local.account_fields[3] 
  subnet_ids_raw = trim(local.account_fields[4], "[]") 
  subnet_ids_list = split(",", replace(local.subnet_ids_raw, " ", "")) 
}

###################################################

#locals { 
#  ec2_security_group_list = ( 
#    can(var.ec2_security_group[0]) ? tolist(var.ec2_security_group) : tolist([var.ec2_security_group])
#  )
#}



resource "aws_instance" "ec2_instance" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_type
  key_name               = "${local.account_id}.${var.ec2_region_deployment}.ec2AccountKey"
  subnet_id              = element(local.subnet_ids_list, 0)
  vpc_security_group_ids = var.ec2_security_group
  #iam_instance_profile   = var.ssm_role


  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
    http_put_response_hop_limit = 2
    instance_metadata_tags  = "enabled"
  }

  tags = {
    Name = "ec2_dev_${var.ec2_name}"
    Env  = var.env
    Application = var.application
    
  }
}
