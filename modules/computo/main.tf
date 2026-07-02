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
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name        = var.instance_name
    Environment = "dev"
  }
}
