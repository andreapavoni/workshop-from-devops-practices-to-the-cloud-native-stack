resource "aws_instance" "bastion" {
  ami      = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.bastion_node_type}"
  key_name      = "${aws_key_pair.key.id}"
  subnet_id     = "${element(aws_subnet.public-subnet.*.id, count.index)}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
    delete_on_termination = "true"
  }

  tags {
    Name = "bastion-avanscoperta-${var.environment}"
  }
}

resource "aws_eip" "bastion" {
  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_eip_association" "bastion" {
  instance_id = "${aws_instance.bastion.id}"
  allocation_id = "${aws_eip.bastion.id}"
}

resource "aws_security_group" "bastion" {
  name        = "allow-ssh-${var.environment}"
  description = "Allow ssh inbound traffic"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "TCP"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "UDP"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

