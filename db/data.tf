data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-mutable1"
    key    = "terraform-mutable1/vpc/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_secretsmanager_secret" "secrets" {
  name = var.ENV
}

data "aws_secretsmanager_secret_version" "secrets-version" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

data "aws_ami" "image" {
  most_recent      = true
  name_regex       = "^Centos-8"
  owners           = ["973714476881"]
}

#data "aws_ami" "ami" {
#  most_recent = true
#  name_regex  = "base"
#  owners      = ["self"]
#}

