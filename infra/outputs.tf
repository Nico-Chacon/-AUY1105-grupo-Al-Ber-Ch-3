output "vpc_id" {
  description = "ID de la VPC"
  value       = module.redes.vpc_id
}

output "subnet_id" {
  description = "ID de la subnet"
  value       = module.redes.subnet_id
}

output "sg_id" {
  description = "ID del Security Group"
  value       = module.redes.sg_id
}

output "igw_id" {
  description = "ID del Internet Gateway"
  value       = module.redes.igw_id
}

output "route_table_id" {
  description = "ID de la Route Table"
  value       = module.redes.route_table_id
}

output "instance_id" {
  description = "ID de la instancia EC2"
  value       = module.computo.instance_id
}

output "ami_id_resolved" {
  description = "AMI efectivamente usada por la instancia"
  value       = module.computo.ami_id_resolved
}

output "instance_ip" {
  description = "IP pública de la instancia EC2"
  value       = module.computo.instance_ip
}
