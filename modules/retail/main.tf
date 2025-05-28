provider "aws" {
  region = "us-east-1"
}


resource "aws_lb" "retail_alb" {
  name               = "retail-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.retail_sg.id] # Add this var if needed
  subnets            = var.subnets

  enable_deletion_protection = false
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.retail_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
}

#module "alb" {
#  source = "./modules"
#
#   vpc_id           = var.vpc_id
#   alb_listener_arn = aws_lb_listener.http.arn
#
#  images = [
#    {
#      name = "retail"
#      tag  = "retail-php"
#      path = "/retail"
#    }
 #,
 #   {
 #     name = "retail"
 #     tag  = "retail-backoffice"
 #     path = "/backoffice"
 #   },
 #   {
 #     name = "retail"
 #     tag  = "retail-billing"
 #     path = "/billing*"
 #   }
#  ]
#}