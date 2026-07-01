provider "aws" {
  region = "us-east-1"
}

module "redes" {
  source            = "../modules/redes"
  vpc_cidr          = "10.2.0.0/16"
  subnet_cidr       = "10.2.1.0/24"
  availability_zone = "us-east-1a"
  allowed_ssh_cidr  = "203.0.113.25/32"
}

output "vpc_id" {
  value = module.redes.vpc_id
}

output "subnet_id" {
  value = module.redes.subnet_id
}

output "sg_id" {
  value = module.redes.sg_id
}
