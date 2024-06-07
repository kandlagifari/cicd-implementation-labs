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


/* ------------------------------------------ S3 Bucket ----------------------------------------- */

variable "s3_bucket_details" {
  type = map(object({
    bucket_name = string
  }))
}


/* --------------------------------------- CodeBuild Role --------------------------------------- */

variable "codebuild_execution_role" {
  type = map(object({
    role_name = string
  }))
}

variable "codebuild_execution_policy" {
  type = map(object({
    policy_name = string
  }))
}


/* ------------------------------------ CW Log for CodeBuild ------------------------------------ */

variable "cloudwatch_log_group" {
  type = map(object({
    cw_log_name = string
  }))
}


/* ------------------------------------- CodeBuild Project -------------------------------------- */

variable "personal_access_token" {
  type = string
}
