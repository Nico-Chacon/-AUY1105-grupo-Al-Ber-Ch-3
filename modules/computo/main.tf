resource "aws_instance" "AUY1105_duocapp_ec2" {
  ami                    = var.ami_id
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
