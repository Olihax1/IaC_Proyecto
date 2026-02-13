# Application Load Balancer (ALB)
resource "aws_lb" "seabook_alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false
}

# Target Group
resource "aws_lb_target_group" "seabook_tg" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

      health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10

  }
}

# Listener 
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.seabook_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.seabook_tg.arn
  }
}

# Asociación WAF -> ALB 
resource "aws_wafv2_web_acl_association" "main" {
  resource_arn = aws_lb.seabook_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.seabook_waf.arn
}