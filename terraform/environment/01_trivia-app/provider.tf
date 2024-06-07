/* ----------------------------- Terraform Block ---------------------------- */

terraform {
  required_providers {
    # required_version = "~> 1.7.0"
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31"
    }
  }

  # backend "s3" {
  #   bucket = "terraform-state-trivia-app-us-east-1"
  #   key    = "s3-website/terraform.tfstate"
  #   region = "us-east-1"

  #   dynamodb_table = "terraform-lock-trivia-app-us-east-1"
  #   encrypt        = true
  # }
}


/* ----------------------------- Provider Block ----------------------------- */

provider "aws" {
  allowed_account_ids = [var.account_id]
  region              = var.region
  profile             = var.aws_profile
  default_tags {
    tags = {
      Environment = "trivia-app"
      Project     = "cicd"
    }
  }
}
