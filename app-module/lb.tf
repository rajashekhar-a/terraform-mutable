resource "aws_lb_target_group" "tg" {
  name     = "${var.COMPONENT}-${var.ENV}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.VPC_ID
}

resource "aws_lb_target_group_attachment" "tg-attach" {
  count            = length(local.INSTANCE_IDS)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = element(local.PRIVATE_IPS, count, index)
  port             = var.PORT
}

resource "aws_lb_listener" "private-listener" {
  load_balancer_arn = data.terraform_remote_state.alb.outputs.PRIVATE_ALB_ARN
  port              = var.PORT
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = var.PORT
      protocol    = "HTTP"
      status_code = "200"
    }
  }
}
resource "aws_lb_listener" "private_listener" {
  load_balancer_arn = data.terraform_remote_state.alb.outputs.PRIVATE_ALB_ARN
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}

