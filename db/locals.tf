 locals {
   DEFAULT_VPC_CIDR = split(",", data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR)
 }
