resource "aws_instance" "mongo" {
  count         = 1
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t3.small"
  key_name      = "${aws_key_pair.key.id}"
  subnet_id     = "${element(aws_subnet.subnet.*.id, count.index)}"

  vpc_security_group_ids = ["${aws_security_group.mongo.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.root_device_size}"
    delete_on_termination = "true"
  }

  tags {
    Name = "mongo-avanscoperta-${var.environment}-${count.index+1}"
    Role = "mongo"
    Gated = "true"
  }
}


resource "aws_security_group" "mongo" {
  name        = "mongo"
  description = "Mongo Security Group"
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

  //sg for backend service
  ingress {
    from_port   = 27017
    to_port     = 27017
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
