output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.AUY1105_duocapp_vpc.id
}

output "subnet_id" {
  description = "ID de la subred pública creada"
  value       = aws_subnet.AUY1105_duocapp_subnet.id
}

output "sg_id" {
  description = "ID del Security Group creado"
  value       = aws_security_group.AUY1105_duocapp_sg.id
}

output "igw_id" {
  description = "ID del Internet Gateway creado"
  value       = aws_internet_gateway.AUY1105_duocapp_igw.id
}

output "route_table_id" {
  description = "ID de la Route Table creada"
  value       = aws_route_table.AUY1105_duocapp_rt.id
}
