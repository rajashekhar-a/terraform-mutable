resource "aws_vpc" "main" {
  cidr_block       = var.VPC_CIDR_MAIN

  tags = {
    Name = var.ENV
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "addon" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.VPC_CIDR_ADDON
}