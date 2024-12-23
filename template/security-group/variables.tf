#################################
### 🌊 Global variables 🌊 #####
#################################

variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "security_group_account_deployment" {
  description  = "retrieve the account id"
  type         = string
}

variable "security_group_region_deployment" {
  description  = "retrieve the account id"
  type         = string
}


############################################
### 🌊 security group variables 🌊 ########
############################################

### 🌊 ingress variables 🌊 ###

variable "security_group_objects" {
  type        = any
  #default     = "rds:TCP:443,80:10.189.96.0/24 rds2:TCP:443:10.189.96.0/24 rds3:TCP:443,88:10.189.96.0/24 rds4:TCP:443,88:10.189.96.0/24"
}
