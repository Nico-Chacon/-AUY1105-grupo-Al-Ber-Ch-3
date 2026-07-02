variable "ami_id" {
  description = "AMI a utilizar para la instancia EC2. Déjalo en null (default) para que se resuelva automáticamente la última Amazon Linux 2023 disponible en la región."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Tipo de instancia EC2 (restringido a t2.micro por política OPA)"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "ID de la subred donde se desplegará la instancia"
  type        = string
}

variable "sg_id" {
  description = "ID del Security Group asociado a la instancia"
  type        = string
}

variable "key_name" {
  description = "Nombre del Key Pair de AWS para acceso SSH"
  type        = string
}

variable "instance_name" {
  description = "Nombre (tag Name) de la instancia EC2"
  type        = string
  default     = "AUY1105-duocapp-ec2"
}

variable "root_volume_size" {
  description = "Tamaño deseado (GB) del disco raíz. Si la AMI exige un mínimo mayor, se usa ese mínimo automáticamente (ver locals.resolved_volume_size)."
  type        = number
  default     = 30
}