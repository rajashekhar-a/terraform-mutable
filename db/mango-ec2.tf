resource "aws_spot_instance_request" "mongo-db" {
  ami                  = data.aws_ami.id
  instance_type        = "var.MONGODB_INSTANCE_TYPE"
  vpc_security_group_ids = [aws_security_group.mongo.id]
  subnet_id            = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS[0]
  wait_for_fulfillment = true

  tags = {
    Name = "mongodb-${var.ENV}"
  }
}

resource "aws_ec2_tag" "example" {
  resource_id = aws_spot_instance_request.mongo-db.id
  key         = "Name"
  value       = "mongodb-${var.ENV}"
}

resource "aws_security_group" "mongo" {
  name        = "mongodb-${var.ENV}"
  description = "mongodb-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress = [
    {
      description      = "MONGO"
      from_port        = 27017
      to_port          = 27017
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
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
    Name = "mongodb-${var.ENV}"
  }
}

resource "aws_route53_record" "mongodb" {
  zone_id = data.terraform_remote_state.vpc.outputs.INTERNAL_HOSTEDZONE_ID
  name    = "mongodb-${var.ENV}"
  type    = "A"
  ttl     = "300"
  records = [aws_spot_instance_request.mongo-db.private_ip]
}

resource "null_resource" "schema-apply" {
  provisioner "remote-exec" {
    connection {
      host = aws_spot_instance_request.mongo-db.private_ip
      user = local.ssh_user
      password = local.ssh_pass
    }
    inline = [
      "ansible-pull -U https://github.com/rajashekhar-a/ansible.git roboshop-pull.yml  -e COMPONENT=mongodb"
    ]
  }
}