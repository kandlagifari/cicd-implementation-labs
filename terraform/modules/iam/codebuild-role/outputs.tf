output "codebuild_execution_role_arn" {
  value = { for k, role in aws_iam_role.codebuild_execution_role : k => role.arn }
}

output "codebuild_execution_role_name" {
  value = { for k, role in aws_iam_role.codebuild_execution_role : k => role.name }
}
