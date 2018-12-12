variable environment {
  default = "workshop"
}
variable vpc_cidr {
  default = "10.100.0.0/16"
}
variable frontend_node_count {
  default = "3"
}
variable frontend_node_type {
  default = "t3.small"
}
variable backend_node_count {
  default = "3"
}
variable backend_node_type {
  default = "t3.small"
}
variable bastion_node_type {
  default = "t3.nano"
}

variable root_device_size {
  default = "50"
}
variable ssh_public_key {
  default = "../secrets/terraform.pub"
}
variable ssh_private_key {
  default = "../secrets/terraform"
}
variable default_ubuntu_ami {
  default = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180912"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["${var.default_ubuntu_ami}"]
  }
}

resource "aws_key_pair" "key" {
  key_name   = "avanscoperta-${var.environment}-key"
  public_key = "${file("${var.ssh_public_key}")}"
}
