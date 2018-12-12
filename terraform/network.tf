resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags {
    Name = "avanscoperta-${var.environment}"
  }
}

// ----------------------------------------- PUBLIC SUBNET ---------------------------------------------
resource "aws_subnet" "public-subnet" {
  count = 3
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, count.index)}"
  map_public_ip_on_launch = true
  tags {
    Name = "public-${count.index}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_eip" "egress-ip" {
  count = "${aws_subnet.public-subnet.count}"
  vpc      = true
  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_nat_gateway" "gw" {
  count = "${aws_subnet.public-subnet.count}"
  allocation_id = "${element(aws_eip.egress-ip.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.public-subnet.*.id,count.index)}"
  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_route_table" "internet-route" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_route_table_association" "public_subnet_eu_west_1a_association" {
    count = "${aws_subnet.public-subnet.count}"
    subnet_id = "${element(aws_subnet.public-subnet.*.id,count.index)}"
    route_table_id = "${aws_route_table.internet-route.id}"
}

// --------- PRIVATE SUBNETS ---------------------
data "aws_availability_zones" "available" {}

resource "aws_subnet" "subnet" {
  count = 3
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, count.index+10)}"
  map_public_ip_on_launch = false
  tags {
    Name = "private-${count.index}"
  }
}

resource "aws_route_table" "route" {
  vpc_id = "${aws_vpc.vpc.id}"
  count = "${aws_subnet.subnet.count}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.gw.*.id,count.index)}"
  }
}
resource "aws_route_table_association" "association" {
    count = "${aws_subnet.subnet.count}"
    subnet_id = "${element(aws_subnet.subnet.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.route.*.id, count.index)}"
}
