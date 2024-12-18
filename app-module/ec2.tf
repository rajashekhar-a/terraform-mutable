resource "aws_spot_instance_request" "spot-instance" {
  count                = var.SPOT_INSTANCE_COUNT
  ami                  = data.aws_ami.ami.id
  instance_type        = var.SPOT_INSTANCE_TYPE
  wait_for_fulfillment = true
  subnet_id            = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS, count.index)

  tags = {
    Name = "sample"
  }
}

resource "aws_instance" "od" {
  count = var.OD_INSTANCE_COUNT
  ami           = data.aws_ami.ami.id
  instance_type = var.INSTANCE_TYPE
  subnet_id     = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS, count.index)
}