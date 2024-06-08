/* ---------------------------------------------------------------------------------------------------------------- */
/*                                              S3 Artifact for CodeBuild                                           */
/* ---------------------------------------------------------------------------------------------------------------- */

module "s3_artifact" {
  source            = "../../modules/s3-bucket"
  create_s3_bucket  = true
  s3_bucket_details = var.s3_bucket_details
}



/* ---------------------------------------------------------------------------------------------------------------- */
/*                                              CW Log Group for CodeBuild                                          */
/* ---------------------------------------------------------------------------------------------------------------- */

module "cw_log" {
  source               = "../../modules/cw-log"
  cloudwatch_log_group = var.cloudwatch_log_group
}



/* ------------------------------------------------------------------------------------------------------------------ */
/*                                                IAM Role for CodeBuild                                              */
/* ------------------------------------------------------------------------------------------------------------------ */

module "codebuild_role" {
  source                     = "../../modules/iam/codebuild-role"
  codebuild_execution_role   = var.codebuild_execution_role
  codebuild_execution_policy = var.codebuild_execution_policy
  account_id                 = data.aws_caller_identity.current.account_id
  region                     = data.aws_region.current.name
  codebuild_s3_artifact_name = module.s3_artifact.bucket_name["trivia-app-codebuild"]
}



/* ------------------------------------------------------------------------------------------------------------------ */
/*                                                  CodeBuild Project                                                 */
/* ------------------------------------------------------------------------------------------------------------------ */

module "codebuild_project" {
  source     = "../../modules/codebuild"
  depends_on = [module.cw_log]

  # Check on `aws codebuild list-source-credentials`
  personal_access_token = var.personal_access_token

  codebuild_project_details = {
    "trivia-app" = {
      # CodeBuild Project Information
      codebuild_name        = "trivia-app-unittests-codebuild-project"
      codebuild_description = "CodeBuild Project for Trivia Application Unit Testing"
      codebuild_timeout     = 60
      codebuild_role        = module.codebuild_role.codebuild_execution_role_arn["trivia-app"]

      # CodeBuild Output Artifacts
      codebuild_bucket_artifacts_name = module.s3_artifact.bucket_name["trivia-app-codebuild"]

      # CodeBuild Container Runtime
      codebuild_environment_compute_type = "BUILD_GENERAL1_SMALL"
      codebuild_environment_image        = "aws/codebuild/standard:7.0"
      codebuild_environment_type         = "LINUX_CONTAINER"

      # CodeBuild Log
      codebuild_cw_log_name = "/aws/codebuild/trivia-app-unittests-codebuild-project"

      # CodeBuild Source
      codebuild_source_provider  = "GITHUB"
      codebuild_source_location  = "https://github.com/kandlagifari/cicd-implementation-labs.git"
      codebuild_source_branch    = "trivia-app"
      codebuild_source_buildspec = "buildspecs/unittests.yaml"
    }
  }

  codebuild_report_group_details = var.codebuild_report_group_details
}



/* ------------------------------------------------------------------------------------------------------------------ */
/*                                               IAM Role for CodePipeline                                            */
/* ------------------------------------------------------------------------------------------------------------------ */

module "codepipeline_role" {
  source                        = "../../modules/iam/codepipeline-role"
  codepipeline_execution_role   = var.codepipeline_execution_role
  codepipeline_execution_policy = var.codepipeline_execution_policy
  account_id                    = data.aws_caller_identity.current.account_id
  # region                     = data.aws_region.current.name
}



/* ------------------------------------------------------------------------------------------------------------------ */
/*                                                 CodePipeline Project                                               */
/* ------------------------------------------------------------------------------------------------------------------ */

module "codepipeline_project" {
  source     = "../../modules/codepipeline"
  depends_on = [module.codebuild_project]

  # # Github Connection (Remove from tfstate, so we don't need configure GitHub Apps again)
  # connection_name     = "trivia-app-github-connection"
  # connection_provider = "GitHub"

  codepipeline_s3_bucket_artifact = module.s3_artifact.bucket_name["trivia-app-codepipeline"]
  # codepipeline_s3_kms_artifact =  data.aws_kms_alias.s3kmskey.arn

  codepipeline_project_details = {
    "trivia-app" = {
      codepipeline_name = "trivia-app-pipeline-project"
      codepipeline_role = module.codepipeline_role.codepipeline_execution_role_arn["trivia-app"]

      codepipeline_action_1_name                   = "Source-Stage"
      codepipeline_action_1_namespace              = "SourceVariables"
      codepipeline_action_1_category               = "Source"
      codepipeline_action_1_owner                  = "AWS"
      codepipeline_action_1_provider               = "CodeStarSourceConnection"
      codepipeline_action_1_version                = "1"
      codepipeline_action_1_output_artifacts       = ["SourceArtifact"]
      codepipeline_action_1_connection_arn         = data.aws_codestarconnections_connection.github.id
      codepipeline_action_1_full_repository_id     = "kandlagifari/cicd-implementation-labs"
      codepipeline_action_1_branch_name            = "trivia-app"
      codepipeline_action_1_detect_changes         = true
      codepipeline_action_1_output_artifact_format = "CODE_ZIP"

      codepipeline_action_2_name             = "Build-Stage"
      codepipeline_action_2_namespace        = "BuildVariables"
      codepipeline_action_2_category         = "Build"
      codepipeline_action_2_owner            = "AWS"
      codepipeline_action_2_provider         = "CodeBuild"
      codepipeline_action_2_version          = "1"
      codepipeline_action_2_input_artifacts  = ["SourceArtifact"]
      codepipeline_action_2_output_artifacts = ["BuildArtifact"]
      codepipeline_action_2_project_name     = "trivia-app-unittests-codebuild-project"
    }
  }
}
