resource "aws_launch_configuration" "frontend" {
  name_prefix = "avanscoperta-${var.environment}-frontend"
  image_id = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.frontend_node_type}"
  key_name = "${aws_key_pair.key.id}"
  security_groups = ["${aws_security_group.frontend.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.root_device_size}"
    delete_on_termination = "true"
  }
}

resource "aws_autoscaling_group" "frontend" {
  name = "avanscoperta-${var.environment}-frontend"
  vpc_zone_identifier = ["${flatten(aws_subnet.subnet.*.id)}"]
  desired_capacity = "${var.frontend_node_count}"
  max_size = "${var.frontend_node_count}"
  min_size = "${var.frontend_node_count}"
  launch_configuration = "${aws_launch_configuration.frontend.name}"

  tags = [
    {
      key = "Role"
      value = "frontend"
      propagate_at_launch = "true"
    }
  ]
}

resource "aws_security_group" "frontend" {
  name        = "frontend"
  description = "Frontend Security Group"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name  = "${var.environment}-avanscoperta"
    Env   = "${var.environment}"
  }

  //sg for ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //sg for webserver
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //allow everything in egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}