###########################################
##  🌐  AWS Provider configuration  🌐  ##
###########################################

provider "aws" {
  region               = var.ec2_region_deployment
   assume_role {
    role_arn          = "arn:aws:iam::113834750184:role/argo-deploy"

  }
  default_tags {
    tags = {
      Environment  = var.env
      Project      = var.project
    }
  }
}

#***************************************************************************************
#  🍄  The algoritem to Retrieve the account id & VPC & SubnetID for deployment  🍄  **
#***************************************************************************************

###################################################

resource "aws_instance" "ec2_instance" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_type
  key_name               = "113834750184.${var.ec2_region_deployment}.ec2AccountKey"
  subnet_id              = "subnet-03dce85b57e01e3a9"
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
