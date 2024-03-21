variable "aws_region" {}
variable "vpc_id" {}
variable "public_subnet_a_id" {}
variable "public_subnet_b_id" {}
variable "private_subnet_id" {}
variable "app_docker_image" {}
variable "image_tag" {}
variable "app_name" {}
variable "container_port" {}
variable "app_access_port" {}
variable "app_instance_type" {}
variable "ssl_cert_arn" {}
variable WEATHER_API_KEY {}
variable LOCATION_API_KEY {}
variable "dockerhub_username" {}
variable "dockerhub_password" {}
variable "app_version" {}

locals {
   aws_region = var.aws_region
   vpc_id = var.vpc_id
   public_subnet_a_id = var.public_subnet_a_id
   public_subnet_b_id = var.public_subnet_b_id
   private_subnet_id = var.private_subnet_id
}
