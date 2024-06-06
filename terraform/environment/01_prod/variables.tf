/* ------------------------------------------- Provider ----------------------------------------- */

variable "account_id" {
  type        = string
  description = "Account ID where the resources will be provisioned."
  default     = "111111111111"
}

variable "region" {
  type        = string
  description = "Region where the resources will be provisioned."
  default     = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS PROFILE environment variable to specify a named profile"
  default     = "default"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "nonprod"
}

variable "apps_name" {
  type        = string
  description = "Application name"
  default     = "trivia-app"
}


/* ----------------------------------------- S3 Bucket --------------------------------------- */

variable "s3_bucket_details" {
  type = map(object({
    bucket_name = string
    source_ip   = string
  }))
}
