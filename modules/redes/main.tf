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


