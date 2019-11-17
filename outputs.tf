output "autoscaling_group_name" {
  value       = "${aws_autoscaling_group.outyet-asg.name}"
  description = "The Terraform generated name of the outyet autoscaling group"
}

output "backend_sg_id" {
  value       = "${aws_security_group.outyet-sg.id}"
  description = "The security group ID of the outyet security group created by this module"
}
