output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.AUY1105_duocapp_ec2.id
}

output "instance_ip" {
  description = "IP pública de la instancia EC2"
  value       = aws_instance.AUY1105_duocapp_ec2.public_ip
}
