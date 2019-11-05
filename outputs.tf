output "autoscaling_group_name" {
  value = "${aws_autoscaling_group.outyet-asg.name}"
}

output "backend_sg_id" {
  value = "${aws_security_group.outyet-sg.id}"
}
