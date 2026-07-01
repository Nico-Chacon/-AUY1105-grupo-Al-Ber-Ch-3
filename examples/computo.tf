provider "aws" {
  region = "us-east-1"
}

module "computo" {
  source        = "../modules/computo"
  ami_id        = "ami-0f403e3180720dd7e"
  instance_type = "t2.micro"
  subnet_id     = "subnet-1234567890abcdef"
  sg_id         = "sg-1234567890abcdef"
  key_name      = "labsuser"
}

output "instance_id" {
  value = module.computo.instance_id
}

output "instance_ip" {
  value = module.computo.instance_ip
}
