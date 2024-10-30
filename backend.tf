terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }

  backend "s3" {
    bucket         = "tfstate-code-challenge-ivaylo"
    key            = "terraform/state-main"
    region         = "eu-west-1"
    dynamodb_table = "tfstate-code-challenge-ivaylo-lock-table"
    encrypt        = true
  }
}