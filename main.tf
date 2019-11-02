data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_launch_configuration" "as-conf" {
  name_prefix     = "outyet"
  image_id        = "${data.aws_ami.amazon-linux-2.id}"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.allow-ssh.id}", "${aws_security_group.allow-out.id}", "${aws_security_group.outyet-sg.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "outyet-asg" {
  name                      = "srecc-outyet"
  max_size                  = 6
  min_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 3
  force_delete              = false
  launch_configuration      = "${aws_launch_configuration.as-conf.name}"
  vpc_zone_identifier       = "${var.subnet_ids}"
}

resource "aws_security_group" "allow-ssh" {
  name        = "allow_ssh"
  description = "Allow inbound SSH from the world"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


