provider "aws" {
  region = var.region
}

module "redes" {
  source            = "../modules/redes"
  vpc_cidr          = var.vpc_cidr
  subnet_cidr       = var.subnet_cidr
  availability_zone = var.availability_zone
  allowed_ssh_cidr  = var.my_ip
}

module "computo" {
  source        = "../modules/computo"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.redes.subnet_id
  sg_id         = "sg-00614b27e69344623"
  key_name      = var.key_name
}
