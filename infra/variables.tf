variable "region" {
  description = "Región de AWS donde se despliega la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "Zona de disponibilidad para la subred"
  type        = string
  default     = "us-east-1a"
}

variable "vpc_cidr" {
  description = "Bloque CIDR para la VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "subnet_cidr" {
  description = "Bloque CIDR para la subred pública"
  type        = string
  default     = "10.1.1.0/24"
}

variable "my_ip" {
  description = "IP pública propia autorizada para acceso SSH (formato x.x.x.x/32)"
  type        = string
  # IMPORTANTE: reemplaza este valor por tu IP pública real antes de aplicar.
  # Puedes obtenerla con: curl -s https://checkip.amazonaws.com
  default = "203.0.113.10/32"
}

variable "ami_id" {
  description = "AMI a utilizar para la instancia EC2. Deja null (default) para resolverla automáticamente (última Amazon Linux 2023 disponible)."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Nombre del Key Pair de AWS ya existente en la cuenta, usado para acceso SSH. En AWS Academy / Learner Lab el Key Pair por defecto se llama 'labsuser'."
  type        = string
  default     = "labsuser"
}
