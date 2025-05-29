resource "aws_lb_target_group" "retail" {
  for_each = { for image in var.images : image.name => image }

  name     = "tg-${each.key}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
 }

resource "aws_lb_listener_rule" "retail" {
  for_each = { for image in var.images : image.name => image }

  listener_arn = aws_lb_listener.http.arn

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