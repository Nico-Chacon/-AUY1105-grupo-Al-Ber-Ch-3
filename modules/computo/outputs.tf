output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.AUY1105_duocapp_ec2.id
}

output "ami_id_resolved" {
  description = "AMI que efectivamente se usó (resuelta automáticamente o provista por variable)"
  value       = local.resolved_ami_id
}

output "instance_ip" {
  description = "IP pública de la instancia EC2"
  value       = aws_instance.AUY1105_duocapp_ec2.public_ip
}
