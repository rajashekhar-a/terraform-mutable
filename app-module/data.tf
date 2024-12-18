data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-mutable1"
    key    = "terraform-mutable1/vpc/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "base"
  owners      = ["self"]
}