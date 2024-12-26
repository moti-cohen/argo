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
  default      = "113834750184"
}

 variable "ec2_region_deployment" {
  type         = string
  default      = "eu-west-1"
}

variable "ec2_ami" {
  type         = string
  default      = "ami-05842291b9a0bd79f"
}

variable "ec2_type" {
    type = string
    default   = "t2.micro"
}

variable "ec2_name" {
    type = string
    default  = "deployed_from_backstage"
}

variable "ec2_security_group" {
   type   = list(string)
   default   = ["sg-086cb401b675c8483"]
}
