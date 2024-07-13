data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-mutable"
    key    = "terraform-mutable/vpc/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_secretsmanager_secret" "secrets" {
  name = var.ENV
}