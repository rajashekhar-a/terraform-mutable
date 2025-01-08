resource "aws_spot_instance_request" "spot-instance" {
  count                  = var.SPOT_INSTANCE_COUNT
  ami                    = data.aws_ami.ami.id
  instance_type          = var.SPOT_INSTANCE_TYPE
  wait_for_fulfillment   = true
  subnet_id              = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS, count.index)
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "${var.COMPONENT}-${var.ENV}"
  }
}

resource "aws_instance" "od" {
  count                  = var.OD_INSTANCE_COUNT
  ami                    = data.aws_ami.ami.id
  instance_type          = var.INSTANCE_TYPE
  subnet_id              = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS, count.index)
  vpc_security_group_ids = [aws_security_group.sg.id]
}

resource "aws_ec2_tag" "tag" {
  count       = length(local.INSTANCE_IDS)
  resource_id = element(local.INSTANCE_IDS, count.index)
  key         = "Name"
  value       = "${var.COMPONENT}-${var.ENV}"
}

resource "aws_ec2_tag" "ec2-monitor-tag" {
  count       = length(local.INSTANCE_IDS)
  resource_id = element(local.INSTANCE_IDS, count.index)
  key         = "monitor"
  value       = "yes"
}

resource "aws_ec2_tag" "ec2-env-tag" {
  count       = length(local.INSTANCE_IDS)
  resource_id = element(local.INSTANCE_IDS, count.index)
  key         = "environment"
  value       = var.ENV
}

locals {
  INSTANCE_IDS = concat(aws_spot_instance_request.spot-instance.*.spot_instance_id, aws_instance.od.*.id)
  PRIVATE_IPS = concat(aws_spot_instance_request.spot-instance.*.private_ip, aws_instance.od.*.private_ip)
}