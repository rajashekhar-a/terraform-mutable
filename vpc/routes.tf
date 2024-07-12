resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.main.id

  route = [
    {
      cidr_block                   = "0.0.0.0/0"
      nat_gateway_id               = aws_nat_gateway.ngw.id
    },
    {
      cidr_block                   = var.DEFAULT_VPC_CIDR
      vpc_peering_connection_id    = aws_vpc_peering_connection.peer.id
      "carrier_gateway_id"         = ""
      "core_network_arn"           = ""
      "destination_prefix_list_id" = ""
      "egress_only_gateway_id"     = ""
      "gateway_id"                 = ""
      "ipv6_cidr_block"            = ""
      "local_gateway_id"           = ""
      "network_interface_id"       = ""
      "transit_gateway_id"         = ""
      "vpc_endpoint_id"            = ""
      "nat_gateway_id"             = ""
    }
  ]


  #  route = [
  #    {
  #      cidr_block                   = var.DEFAULT_VPC_CIDR
  #      vpc_peering_connection_id    = aws_vpc_peering_connection.peer.id
  #      carrier_gateway_id           = ""
  #      "destination_prefix_list_id" = ""
  #      "egress_only_gateway_id"     = ""
  #      "gateway_id"                 = ""
  #      "instance_id"                = ""
  #      "ipv6_cidr_block"            = ""
  #      "local_gateway_id"           = ""
  #      "nat_gateway_id"             = ""
  #      "network_interface_id"       = ""
  #      "transit_gateway_id"         = ""
  #      "vpc_endpoint_id"            = ""
  #      "core_network_arn"           = ""
  #    },
  #    {
  #      cidr_block                   = "0.0.0.0/0"
  #      vpc_peering_connection_id    = ""
  #      carrier_gateway_id           = ""
  #      "destination_prefix_list_id" = ""
  #      "egress_only_gateway_id"     = ""
  #      "gateway_id"                 = ""
  #      "instance_id"                = ""
  #      "ipv6_cidr_block"            = ""
  #      "local_gateway_id"           = ""
  #      "nat_gateway_id"             = aws_nat_gateway.ngw.id
  #      "network_interface_id"       = ""
  #      "transit_gateway_id"         = ""
  #      "vpc_endpoint_id"            = ""
  #      "core_network_arn"           = ""
  #    }
  #  ]

  tags = {
    Name = "private-route"
  }
}

resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.main.id

  route = [
    {
      cidr_block                   = "0.0.0.0/0"
      "gateway_id"                 = aws_internet_gateway.igw.id
    },
    {
      cidr_block                   = var.DEFAULT_VPC_CIDR
      vpc_peering_connection_id    = aws_vpc_peering_connection.peer.id
      "carrier_gateway_id"         = ""
      "core_network_arn"           = ""
      "destination_prefix_list_id" = ""
      "egress_only_gateway_id"     = ""
      "gateway_id"                 = ""
      "ipv6_cidr_block"            = ""
      "local_gateway_id"           = ""
      "network_interface_id"       = ""
      "transit_gateway_id"         = ""
      "vpc_endpoint_id"            = ""
      "vpc_peering_connection_id"  = ""
      "nat_gateway_id"             = ""
    }
  ]

  #  route = [
  #    {
  #      cidr_block                   = var.DEFAULT_VPC_CIDR
  #      vpc_peering_connection_id    = aws_vpc_peering_connection.peer.id
  #      carrier_gateway_id           = ""
  #      "destination_prefix_list_id" = ""
  #      "egress_only_gateway_id"     = ""
  #      "gateway_id"                 = ""
  #      "instance_id"                = ""
  #      "ipv6_cidr_block"            = ""
  #      "local_gateway_id"           = ""
  #      "nat_gateway_id"             = ""
  #      "network_interface_id"       = ""
  #      "transit_gateway_id"         = ""
  #      "vpc_endpoint_id"            = ""
  #      "core_network_arn"           = ""
  #    },
  #    {
  #      cidr_block                   = "0.0.0.0/0"
  #      vpc_peering_connection_id    = ""
  #      carrier_gateway_id           = ""
  #      "destination_prefix_list_id" = ""
  #      "egress_only_gateway_id"     = ""
  #      "gateway_id"                 = aws_internet_gateway.igw.id
  #      "instance_id"                = ""
  #      "ipv6_cidr_block"            = ""
  #      "local_gateway_id"           = ""
  #      "nat_gateway_id"             = ""
  #      "network_interface_id"       = ""
  #      "transit_gateway_id"         = ""
  #      "vpc_endpoint_id"            = ""
  #      "core_network_arn"           = ""
  #    }
  #  ]

  tags = {
    Name = "public-route"
  }
}

