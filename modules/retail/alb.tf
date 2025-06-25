provider "aws" {
  region = "us-east-1"
}

resource "aws_lb" "retail_alb" {
  name               = "retail-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.retail_sg.id]
  subnets            = var.subnets
  enable_deletion_protection = false
}

# HTTP listener (80) ONLY redirects to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.retail_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS listener (443) with certificate
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.retail_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.wildcard.certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_target_group" "retail" {
  for_each = { for image in var.images : image.service_name => image }

  name        = "tg-${each.value.service_name}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health-check"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Listener rules: FORWARD on HTTPS only!
resource "aws_lb_listener_rule" "retail" {
  for_each = { for image in var.images : image.service_name => image }

  listener_arn = aws_lb_listener.https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.retail[each.key].arn
  }

  condition {
    path_pattern {
      values = [each.value.path]
    }
  }
}
