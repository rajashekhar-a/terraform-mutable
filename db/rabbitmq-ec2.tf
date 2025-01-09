resource "aws_spot_instance_request" "rabbitmq" {
  ami                    = data.aws_ami.image.id
  instance_type          = var.RABBITMQ_INSTANCE_TYPE
  vpc_security_group_ids = [aws_security_group.rabbitmq.id]
  subnet_id              = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS[0]
  wait_for_fulfillment   = true

  tags = {
    Name = "rabbitmq-${var.ENV}"
  }
}

resource "aws_ec2_tag" "rabbitmq" {
  resource_id = aws_spot_instance_request.rabbitmq.id
  key         = "Name"
  value       = "rabbitmq-${var.ENV}"
}

resource "aws_security_group" "rabbitmq" {
  name        = "rabbitmq-${var.ENV}"
  description = "rabbitmq-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress = [
    {
      description      = "RABBITMQ"
      from_port        = 5672
      to_port          = 5672
      protocol         = "tcp"
      cidr_blocks      = local.ALL_CIDR
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = local.ALL_CIDR
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
    Name = "rabbitmq-${var.ENV}"
  }
}

resource "aws_route53_record" "rabbitmq" {
  zone_id = data.terraform_remote_state.vpc.outputs.INTERNAL_HOSTEDZONE_ID
  name    = "rabbitmq-${var.ENV}"
  type    = "A"
  ttl     = "300"
  records = [aws_spot_instance_request.rabbitmq.private_ip]
}

resource "null_resource" "schema-apply" {
  provisioner "remote-exec" {
    connection {
      host     = aws_spot_instance_request.rabbitmq.private_ip
      user     = local.ssh_user
      password = local.ssh_pass
    }
    inline = [
      "yum install python3-pip -y",
      "pip3 install pip --upgrade",
      "pip3 install ansible",
      "ansible-pull -U https://github.com/rajashekhar-a/ansible.git roboshop-pull.yml  -e ENV=${var.ENV}-e COMPONENT=rabbitmq"
    ]
  }
}