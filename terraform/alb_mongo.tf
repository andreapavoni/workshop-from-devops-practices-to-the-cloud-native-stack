resource "aws_lb" "mongo" {
  name               = "avanscoperta-${var.environment}-mongo"
  internal           = true
  load_balancer_type = "network"
  subnets             = ["${flatten(aws_subnet.subnet.*.id)}"]
  security_groups = ["${aws_security_group.mongo-alb.id}"]
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = false
  idle_timeout = 400
  tags {
    Name = "avanscoperta-${var.environment}-mongo"
    Environment = "${var.environment}"
  }
}

// resource "aws_lb_listener" "mongo" {
//   load_balancer_arn = "${aws_lb.mongo.arn}"
//   port              = "27017"
//   protocol          = "TCP"
//   default_action {
//     type             = "forward"
//     target_group_arn = "${aws_lb_target_group.mongo.arn}"
//   }
// }

// resource "aws_lb_target_group" "mongo" {
//   name     = "mongo"
//   port     = 27017
//   protocol = "TCP"
//   vpc_id   = "${aws_vpc.vpc.id}"
//   target_type = "instance"
//   health_check {
//     protocol            = "TCP"
//     port                = "27017"
//   }
// }

resource "aws_security_group" "mongo-alb" {
  name        = "mongo-alb"
  description = "mongo ALB Security Group"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name = "avanscoperta-alb-${var.environment}-mongo"
  }

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
