
module "vpc" {
  source = "./vpc_deploy"
  aws_region = var.aws_region
  AZs = var.AZs

  app_name = var.app_name
}

module "app" {
  source = "./app_deploy"

  aws_region = module.vpc.details["aws_region"]
  vpc_id = module.vpc.details["vpc_id"]
  public_subnet_a_id = module.vpc.details["public_subnet_a_id"]
  public_subnet_b_id = module.vpc.details["public_subnet_b_id"]
  private_subnet_id = module.vpc.details["private_subnet_id"]
  ssl_cert_arn = var.ssl_cert_arn
  app_docker_image = var.app_docker_image
  image_tag = var.image_tag
  app_name = var.app_name
  container_port = var.container_port
  app_access_port = var.app_access_port
  app_instance_type = var.app_instance_type
  WEATHER_API_KEY = var.WEATHER_API_KEY
  LOCATION_API_KEY = var.LOCATION_API_KEY
  dockerhub_username = var.dockerhub_username
  dockerhub_password = var.dockerhub_password
  app_version = var.app_version

  depends_on = [module.vpc]
}

module "bastion" {
  source = "./bastion_host"

  vpc_id = module.app.details["vpc_id"]
  public_subnet_id = module.app.details["public_subnet_a_id"]
  private_subnet_id = module.app.details["private_subnet_id"]
  app_private_ip = module.app.details["private_ip"]
  app_name = var.app_name
  app_private_key = module.app.private_key

  depends_on = [module.app]
}
