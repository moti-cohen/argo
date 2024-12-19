output "security_group_arn" {
  value  = [for sg  in aws_security_group.torque_resources : sg.id]
  #value  = aws_security_group.torque_resources.id
}


#output "security_group_segments" {
#  value = local.security_group_list
#}

#output "security_group_objects" {
#  value = local.security_group_objects
#}
