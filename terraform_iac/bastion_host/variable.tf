
variable "vpc_id" {}
variable "public_subnet_id" {}
variable "private_subnet_id" {}
variable "app_private_ip" {}
variable "app_name" {}
variable "app_private_key" {}

locals {
   vpc_id = var.vpc_id
   public_subnet_id = var.public_subnet_id
   private_subnet_id = var.private_subnet_id
   app_private_ip = var.app_private_ip
}

