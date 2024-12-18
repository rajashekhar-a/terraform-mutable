locals {
  VPC_CIDR_MAIN = split(",", var.VPC_CIDR_MAIN)
  #ALL_VPC_CIDR  = concat(local.VPC_CIDR_MAIN, var.VPC_CIDR_ADDON)
}

