module "s3_website" {
  source            = "../../modules/s3-bucket"
  create_s3_bucket  = true
  s3_bucket_details = var.s3_bucket_details
}



/* ------------------------------------------------------------------------------------------------------------------ */
/*                                              CW Log Group for CodeBuild                                            */
/* ------------------------------------------------------------------------------------------------------------------ */

module "sit_cw_log_lambda" {
  source               = "../../modules/cw-log"
  cloudwatch_log_group = var.cloudwatch_log_group
}



/* ------------------------------------------------------------------------------------------------------------------ */
/*                                                IAM Role for CodeBuild                                              */
/* ------------------------------------------------------------------------------------------------------------------ */

module "sit_eventbridge_role" {
  source                                        = "../../modules/iam/eventbridge-role"
  codebuild_execution_role         = var.codebuild_execution_role
  codebuild_execution_policy = var.codebuild_execution_policy
  account_id                                    = data.aws_caller_identity.current.account_id
  region                                        = data.aws_region.current.name
}
