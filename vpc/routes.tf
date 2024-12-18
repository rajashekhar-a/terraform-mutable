resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.main.id

  route = [
    {
      cidr_block                = var.DEFAULT_VPC_CIDR
      vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
    },
    {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.ngw.id
    }
  ]
  tags = {
    Name = "private-route"
  }
}
resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.main.id

  route = [
    {
      cidr_block                = var.DEFAULT_VPC_CIDR
      vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
    },
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
  ]

  tags = {
    Name = "public-route"
  }
}


#resource "aws_route" "private_route_to_main_route" {
#  route_table_id            = aws_route_table.private-route.id
#  destination_cidr_block    = var.DEFAULT_VPC_CIDR
#  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
#}
#
#resource "aws_route" "public_route_to_main_route" {
#  route_table_id            = aws_route_table.public-route.id
#  destination_cidr_block    = var.DEFAULT_VPC_CIDR
#  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
#}
#
#resource "aws_route" "main_route_to_private_route" {
#  route_table_id            = var.DEFAULT_VPC_ROUTE_TABLE_ID
#  destination_cidr_block    = var.VPC_CIDR_MAIN
#  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
#}
#
#resource "aws_route" "main_route_to_public_route" {
#  route_table_id            = var.DEFAULT_VPC_ROUTE_TABLE_ID
#  destination_cidr_block    = var.VPC_CIDR_ADDON
#  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
#}add

resource "aws_route" "route-from-default-vpc" {
  count                     = length(local.association-list)
  route_table_id            = tomap(element(local.association-list, count.index))["route_table"]
  destination_cidr_block    = tomap(element(local.association-list, count.index))["cidr"]
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

