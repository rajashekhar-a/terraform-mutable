locals {
  ALL_VPC_CIDR = split(",", "var.VPC_CIDR_MAIN, var.VPC_CIDR_ADDON")
}
