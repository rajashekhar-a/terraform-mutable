resource "aws_lb" "private-alb" {
  name               = "roboshop-private-${var.ENV}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private-alb.id]
  subnets            = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS

  enable_deletion_protection = false

  tags = {
    Environment = "roboshop-private-${var.ENV}"
  }
}

resource "aws_security_group" "private-alb" {
  name        = "roboshop-private-alb-${var.ENV}"
  description = "roboshop-private-alb-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "egress"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "roboshop-private-alb-${var.ENV}"
  }
}

resource "aws_lb_listener" "private-listener" {
  load_balancer_arn = aws_lb.private-alb.arn
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