resource "aws_lb" "mongo" {
  name               = "avanscoperta-${var.environment}-mongo"
  internal           = true
  load_balancer_type = "network"
  subnets             = ["${flatten(aws_subnet.subnet.*.id)}"]
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = false
  idle_timeout = 400
  tags {
    Name = "avanscoperta-${var.environment}-mongo"
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener" "mongo" {
  load_balancer_arn = "${aws_lb.mongo.arn}"
  port              = "27017"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.mongo.arn}"
  }
}

resource "aws_lb_target_group" "mongo" {
  name     = "mongo"
  port     = 27017
  protocol = "TCP"
  vpc_id   = "${aws_vpc.vpc.id}"
  target_type = "instance"
  health_check {
    protocol            = "TCP"
    port                = "27017"
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = "${aws_lb_target_group.mongo.arn}"
  target_id        = "${aws_instance.mongo.id}"
}
