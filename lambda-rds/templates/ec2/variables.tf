variable "project" {
    type = string
    default  = "ec2_deployed_from_backstage"
}

variable "env" {
    type = string
    default  = "ec2_deployed_from_backstage"
}

variable "application" {
    type = string
    default  = "ec2_deployed_from_backstage"
}

variable "ec2_account_deployment" {
  description  = "retrieve the account id"
  type         = string
}

 variable "ec2_region_deployment" {
  type         = string
}

variable "ec2_ami" {
  type         = string
}

variable "ec2_type" {
    type = string
}

variable "ec2_name" {
    type = string
    default  = "ec2_deployed_from_backstage"
}

variable "ec2_security_group" {
   type   = list(string)
}
