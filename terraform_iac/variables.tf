variable "aws_region" {}
variable "awscli_cred_dict" {}
variable "app_docker_image" {}
variable "image_tag" {}
variable "app_name" {}
variable "container_port" {}
variable "app_access_port" {}
variable "app_instance_type" {}
variable "AZs" {
  type        = list(string)
}
variable "WEATHER_API_KEY" {}
variable "LOCATION_API_KEY" {}
variable "ssl_cert_arn" {}
variable "dockerhub_username" {}
variable "dockerhub_password" {}
variable "app_version" {}
