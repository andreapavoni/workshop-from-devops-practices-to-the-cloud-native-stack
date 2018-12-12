resource "aws_lb" "frontend" {
  name               = "avanscoperta-${var.environment}-frontend"
  internal           = false
  load_balancer_type = "application"
  subnets             = ["${flatten(aws_subnet.public-subnet.*.id)}"]
  security_groups = ["${aws_security_group.frontend-alb.id}"]
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = false
  idle_timeout = 400
  tags {
    Name = "avanscoperta-${var.environment}-frontend"
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = "${aws_lb.frontend.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.frontend.arn}"
  }
}

resource "aws_lb_target_group" "frontend" {
  name     = "frontend"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"
  target_type = "instance"
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    protocol            = "HTTP"
    port                = "80"
  }
}

resource "aws_autoscaling_attachment" "frontend" {
  autoscaling_group_name = "${aws_autoscaling_group.frontend.id}"
  alb_target_group_arn   = "${aws_lb_target_group.frontend.arn}"
}

resource "aws_security_group" "frontend-alb" {
  name        = "frontend-alb"
  description = "Frontend ALB Security Group"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name = "avanscoperta-alb-${var.environment}-frontend"
  }

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
