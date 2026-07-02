# Resuelve automáticamente la AMI más reciente de Amazon Linux 2023 (x86_64, HVM)
# en la región configurada, para no tener que buscar/pegar un AMI ID a mano.
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

locals {
  # Si var.ami_id viene definido (no null), se respeta; si no, se usa la AMI resuelta automáticamente.
  resolved_ami_id = coalesce(var.ami_id, data.aws_ami.amazon_linux_2023.id)

  ami_root_bdm = try([
    for b in data.aws_ami.amazon_linux_2023.block_device_mappings :
    b if b.device_name == data.aws_ami.amazon_linux_2023.root_device_name
  ][0], null)

  ami_min_volume_size = try(tonumber(local.ami_root_bdm.ebs["volume_size"]), 30)

  resolved_volume_size = max(var.root_volume_size, local.ami_min_volume_size)
}

resource "aws_instance" "AUY1105_duocapp_ec2" {
  ami                    = local.resolved_ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  key_name               = var.key_name

  ebs_optimized = true
  monitoring    = true

  metadata_options {
    http_tokens   = "required" # Fuerza IMDSv2
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted   = true
    volume_size = local.resolved_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name        = var.instance_name
    Environment = "dev"
  }
}
