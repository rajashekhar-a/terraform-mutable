resource "aws_lb_target_group" "tg" {
  name     = "${var.COMPONENT}-${var.ENV}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.VPC_ID
}

resource "aws_lb_target_group_attachment" "tg-attach" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = element(local.PRIVATE_IPS, count, index)
  port             = var.PORT
}

