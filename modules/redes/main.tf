resource "aws_vpc" "AUY1105_duocapp_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "AUY1105_duocapp_subnet" {
  vpc_id                  = aws_vpc.AUY1105_duocapp_vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_name
  }
}

resource "aws_internet_gateway" "AUY1105_duocapp_igw" {
  vpc_id = aws_vpc.AUY1105_duocapp_vpc.id

  tags = {
    Name = "AUY1105-duocapp-igw"
  }
}

resource "aws_route_table" "AUY1105_duocapp_rt" {
  vpc_id = aws_vpc.AUY1105_duocapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.AUY1105_duocapp_igw.id
  }

  tags = {
    Name = "AUY1105-duocapp-rt"
  }
}

resource "aws_route_table_association" "AUY1105_duocapp_rta" {
  subnet_id      = aws_subnet.AUY1105_duocapp_subnet.id
  route_table_id = aws_route_table.AUY1105_duocapp_rt.id
}

resource "aws_security_group" "AUY1105_duocapp_sg" {
  name        = var.sg_name
  description = "SG para instancias EC2 - solo SSH desde IP autorizada"
  vpc_id      = aws_vpc.AUY1105_duocapp_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
    description = "Acceso SSH desde IP autorizada"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Salida total"
  }

  tags = {
    Name = var.sg_name
  }
}
