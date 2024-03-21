
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2.0"
    }
  }

  backend "s3" {
    bucket         = "webapp-tf-backend"
    key            = "tf_backend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "webapp-tf-lock"
    encrypt        = true
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "default"
  }
}

provider "aws" {
  region     = var.aws_region
  shared_credentials_files = ["~/.aws/credentials"]
  profile                 = ""
}
