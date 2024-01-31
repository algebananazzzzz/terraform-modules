provider "aws" {
  region  = var.aws_region
  profile = var.profile

  default_tags {
    tags = {
      Environment = var.env
      ProjectCode = var.project_code
    }
  }
}

terraform {
  required_version = ">=1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.31.0"
    }
  }

  backend "s3" {
    bucket               = "xxx"
    key                  = "xxx.tfstate"
    workspace_key_prefix = "tf-state"
    region               = "ap-southeast-1"
  }
}
