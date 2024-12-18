resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.main.id

  route = [
    {
      cidr_block                   = var.DEFAULT_VPC_CIDR
      vpc_peering_connection_id    = aws_vpc_peering_connection.peer.id
      carrier_gateway_id           = ""
      "core_network_arn"           = ""
      "destination_prefix_list_id" = ""
      "egress_only_gateway_id"     = ""
      "gateway_id"                 = ""
      "instance_id"                = ""
      "ipv6_cidr_block"            = ""
      "local_gateway_id"           = ""
      "nat_gateway_id"             = ""
      "network_interface_id"       = ""
      "transit_gateway_id"         = ""
      "vpc_endpoint_id"            = ""
    },
    {
      cidr_block                   = "0.0.0.0/0"
      vpc_peering_connection_id    = ""
      carrier_gateway_id           = ""
      "core_network_arn"           = ""
      "destination_prefix_list_id" = ""
      "egress_only_gateway_id"     = ""
      "gateway_id"                 = ""
      "instance_id"                = ""
      "ipv6_cidr_block"            = ""
      "local_gateway_id"           = ""
      "nat_gateway_id"             = aws_nat_gateway.ngw.id
      "network_interface_id"       = ""
      "transit_gateway_id"         = ""
      "vpc_endpoint_id"            = ""
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
      cidr_block                   = var.DEFAULT_VPC_CIDR
      vpc_peering_connection_id    = aws_vpc_peering_connection.peer.id
      carrier_gateway_id           = ""
      "core_network_arn"           = ""
      "destination_prefix_list_id" = ""
      "egress_only_gateway_id"     = ""
      "gateway_id"                 = ""
      "instance_id"                = ""
      "ipv6_cidr_block"            = ""
      "local_gateway_id"           = ""
      "nat_gateway_id"             = ""
      "network_interface_id"       = ""
      "transit_gateway_id"         = ""
      "vpc_endpoint_id"            = ""
    },
    {
      cidr_block                   = "0.0.0.0/0"
      vpc_peering_connection_id    = ""
      carrier_gateway_id           = ""
      "destination_prefix_list_id" = ""
      "core_network_arn"           = ""
      "egress_only_gateway_id"     = ""
      "gateway_id"                 = aws_internet_gateway.igw.id
      "instance_id"                = ""
      "ipv6_cidr_block"            = ""
      "local_gateway_id"           = ""
      "nat_gateway_id"             = ""
      "network_interface_id"       = ""
      "transit_gateway_id"         = ""
      "vpc_endpoint_id"            = ""
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

