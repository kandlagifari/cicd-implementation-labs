resource "aws_codestarconnections_connection" "this" {
  name          = var.connection_name
  provider_type = var.connection_provider
}

# resource "aws_codepipeline" "this" {
#   for_each = var.codepipeline_project_details
#   name     = each.value["codepipeline_name"]
#   role_arn = each.value["codepipeline_role"]

#   artifact_store {
#     location = var.codepipeline_s3_bucket_artifact
#     type     = "S3"

#     encryption_key {
#       id   = var.codepipeline_s3_kms_artifact
#       type = "KMS"
#     }
#   }

#   stage {
#     name = each.value["codepipeline_action_name_1"] # "Source"

#     action {
#       name             = each.value["codepipeline_action_1_name"]
#       category         = each.value["codepipeline_action_1_category"]
#       owner            = each.value["codepipeline_action_1_owner"] 
#       provider         = each.value["codepipeline_action_1_provider"] 
#       version          = each.value["codepipeline_action_1_version"] 
#       output_artifacts = each.value["codepipeline_action_1_output_artifacts"] 

#       configuration = {
#         ConnectionArn    = each.value["codepipeline_action_1_connection_arn"] 
#         FullRepositoryId = each.value["codepipeline_action_1_full_repository_id"] 
#         BranchName       = each.value["codepipeline_action_1_branch_name"] 
#       }
#     }
#   }

#   stage {
#     name = each.value["codepipeline_action_name_2"] # "Build"

#     action {
#       name             = each.value["codepipeline_action_2_name"]
#       category         = each.value["codepipeline_action_2_category"]
#       owner            = each.value["codepipeline_action_2_owner"] 
#       provider         = each.value["codepipeline_action_2_provider"] 
#       version          = each.value["codepipeline_action_2_version"] 
#       input_artifacts  = each.value["codepipeline_action_2_input_artifacts"] 
#       output_artifacts = each.value["codepipeline_action_2_output_artifacts"] 
#       # version          = "1" # Only valid for Jenkins

#       configuration = {
#         ProjectName = each.value["codepipeline_action_2_project_name"] 
#       }
#     }
#   }

#   # stage {
#   #   name = "Deploy"

#   #   action {
#   #     name            = "Deploy"
#   #     category        = "Deploy"
#   #     owner           = "AWS"
#   #     provider        = "CloudFormation"
#   #     input_artifacts = ["build_output"]
#   #     version         = "1"

#   #     configuration = {
#   #       ActionMode     = "REPLACE_ON_FAILURE"
#   #       Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
#   #       OutputFileName = "CreateStackOutput.json"
#   #       StackName      = "MyStack"
#   #       TemplatePath   = "build_output::sam-templated.yaml"
#   #     }
#   #   }
#   # }
# }
