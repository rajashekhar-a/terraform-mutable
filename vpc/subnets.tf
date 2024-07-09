resource "aws_subnet" "private-subnets" {
  count      = length(var.PRIVATE_SUBNETS)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.PRIVATE_SUBNETS, count.index)
  availability_zone = element(var.AZS, count.index)

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_subnet" "public-subnets" {
  count      = length(var.PUBLIC_SUBNETS)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.PUBLIC_SUBNETS, count.index)
  availability_zone = element(var.AZS, count.index)

  tags = {
    Name = "public-subnet-${count.index}"
  }
}