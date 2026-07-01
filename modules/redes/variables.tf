variable "vpc_cidr" {
  description = "Bloque CIDR para la VPC"
  type        = string
}

variable "vpc_name" {
  description = "Nombre (tag Name) de la VPC"
  type        = string
  default     = "AUY1105-duocapp-vpc"
}

variable "subnet_cidr" {
  description = "Bloque CIDR para la subred pública"
  type        = string
}

variable "subnet_name" {
  description = "Nombre (tag Name) de la subred"
  type        = string
  default     = "AUY1105-duocapp-subnet"
}

variable "availability_zone" {
  description = "Zona de disponibilidad para la subred"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Rango CIDR autorizado para acceso SSH (usualmente tu IP pública /32)"
  type        = string
}

variable "sg_name" {
  description = "Nombre del Security Group"
  type        = string
  default     = "AUY1105-duocapp-sg"
}
