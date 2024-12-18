resource "aws_lb" "private-alb" {
  name               = "roboshop-private-${var.ENV}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private-alb.id]
  subnets            = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS

  enable_deletion_protection = false

  tags = {
    Environment = "private-alb-{var.ENV}"
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