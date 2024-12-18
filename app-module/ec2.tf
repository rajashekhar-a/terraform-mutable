resource "aws_spot_instance_request" "spot-instance" {
  ami           = "ami-1234"
  instance_type = var.SPOT_INSTANCE_TYPE
  wait_for_fulfillment = true
  subnet_id = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS, count.index)

   tags = {
    Name = "CheapWorker"
  }
}

resource "aws_instance" "od" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.INSTANCE_TYPE
  subnet_id              = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS, count.index)
}