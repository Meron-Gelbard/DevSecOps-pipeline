variable "aws_region" {
  default = "us-east-1"
}
variable "awscli_cred_dict" {
  default = ["~/.aws/credentials"]
}
variable "image_tag" {
  default = "latest"
}
variable "app_name" {
  default = "WEB-APP"
}
variable "container_port" {
  default = 8080
}
variable "app_access_port" {
  default = 80
}
variable "app_instance_type" {
  default = "t2.micro"
}
variable "AZs" {
  type        = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
variable "WEATHER_API_KEY" {}
variable "LOCATION_API_KEY" {}
variable "ssl_cert_arn" {}
variable "app_docker_image" {}
variable "dockerhub_username" {}
variable "dockerhub_password" {}
variable "app_version" {}

