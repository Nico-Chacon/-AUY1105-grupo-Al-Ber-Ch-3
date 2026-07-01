package terraform.security

# Bloquear SSH abierto a todo el mundo
deny[msg] if {
  input.resource_type == "aws_security_group"
  ingress := input.ingress[_]
  ingress.cidr_blocks[_] == "0.0.0.0/0"
  msg := "SSH abierto a todo el mundo no está permitido"
}

# Solo se permiten instancias t2.micro
deny[msg] if {
  input.resource_type == "aws_instance"
  input.instance_type != "t2.micro"
  msg := "Solo se permiten instancias t2.micro"
}
