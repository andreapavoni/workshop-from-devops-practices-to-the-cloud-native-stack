resource "aws_lb" "backend" {
  name               = "avanscoperta-${var.environment}-backend"
  internal           = true
  load_balancer_type = "application"
  subnets             = ["${flatten(aws_subnet.subnet.*.id)}"]
  security_groups = ["${aws_security_group.backend-alb.id}"]
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = false
  idle_timeout = 400
  tags {
    Name = "avanscoperta-${var.environment}-backend"
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = "${aws_lb.backend.arn}"
  port              = "3000"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.backend.arn}"
  }
}

resource "aws_lb_target_group" "backend" {
  name     = "backend"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"
  target_type = "instance"
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    protocol            = "HTTP"
    port                = "3000"
  }
}

resource "aws_autoscaling_attachment" "backend" {
  autoscaling_group_name = "${aws_autoscaling_group.backend.id}"
  alb_target_group_arn   = "${aws_lb_target_group.backend.arn}"
}

resource "aws_security_group" "backend-alb" {
  name        = "backend-alb"
  description = "Backend ALB Security Group"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name = "avanscoperta-alb-${var.environment}-backend"
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
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
