resource "aws_alb" "main_alb" {
  name = "${var.alb_name}-alb"
  subnets = var.public_subnet_ids
  security_groups = [var.alb_sg_id]
}

resource "aws_alb_target_group" "target_app" {
  name = "${var.alb_name}-target-group"
  port = var.app_port
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "ip"
  health_check {
    path = var.health_check_path
    protocol = "HTTP"
    interval = 30
    timeout = 3
    matcher = 200
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.target_app.arn
  }
}