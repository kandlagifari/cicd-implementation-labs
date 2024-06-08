output "codebuild_project_name" {
  value = { for k, codebuild in aws_codebuild_project.this : k => codebuild.id }
}
