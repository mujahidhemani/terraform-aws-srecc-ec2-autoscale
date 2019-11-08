resource "aws_launch_configuration" "as-conf" {
  name_prefix     = "outyet"
  image_id        = "ami-038c8cb0197602e21"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.allow-out.id}", "${aws_security_group.outyet-sg.id}"]
  associate_public_ip_address = false
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "outyet-asg" {
  name                      = "${aws_launch_configuration.as-conf.name}"
  max_size                  = 6
  min_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 3
  force_delete              = false
  launch_configuration      = "${aws_launch_configuration.as-conf.name}"
  vpc_zone_identifier       = "${var.subnet_ids}"
  target_group_arns         = ["${var.target_group_arn}"]

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group" "allow-out" {
  name        = "allow_out"
  description = "allow web traffic out"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "outyet-sg" {
  name        = "outyet-sg"
  description = "port 8080 for outyet app"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    self      = true
  }

  lifecycle {
    create_before_destroy = true
  }

}


