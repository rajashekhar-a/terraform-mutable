resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = aws_subnet.private-subnets.id
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

    tags = {
    Name = "private-route"
  }
}

resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = aws_subnet.public-subnets.id
    gateway_id     = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route"
  }
}