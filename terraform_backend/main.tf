terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.2"
    }
  }
}

provider "aws" {
  region                 = var.aws_region
  shared_credentials_file = "~/.aws/credentials"
  profile                = "default"
}


resource "aws_s3_bucket" "tf-remote-backend" {
  bucket = "webapp-tf-backend"

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_dynamodb_table" "backend_lock" {
  name           = "webapp-tf-lock"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1  
  billing_mode   = "PROVISIONED"
  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    ignore_changes = all
  }
}


resource "null_resource" "empty_backend_bucket" {
  provisioner "local-exec" {
    command = "aws s3 rm s3://webapp-tf-backend --recursive"
    when    = destroy
  }
}