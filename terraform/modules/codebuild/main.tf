resource "aws_codebuild_source_credential" "this" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.personal_access_token
}

resource "aws_codebuild_project" "this" {
  for_each      = var.codebuild_project_details
  name          = each.value["codebuild_name"]
  description   = each.value["codebuild_description"]
  build_timeout = each.value["codebuild_timeout"]
  service_role  = each.value["codebuild_role"]

  artifacts {
    type                   = "S3"
    location               = each.value["codebuild_bucket_artifacts_name"]
    packaging              = "ZIP"
    override_artifact_name = true
  }

  # cache {
  #   type     = "S3"
  #   location = aws_s3_bucket.this.bucket
  # }

  environment {
    compute_type                = each.value["codebuild_environment_compute_type"] # "BUILD_GENERAL1_SMALL"
    image                       = each.value["codebuild_environment_image"]        # "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = each.value["codebuild_environment_type"]         # "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name = each.value["codebuild_cw_log_name"]
      # stream_name = "log-stream"
    }

    # s3_logs {
    #   status   = "ENABLED"
    #   location = "${aws_s3_bucket.this.id}/build-log"
    # }
  }

  source {
    type            = each.value["codebuild_source_provider"] # "GITHUB"
    location        = each.value["codebuild_source_location"] # "https://github.com/kandlagifari/cicd-implementation-labs.git"
    git_clone_depth = 1
    buildspec       = "buildspec.yml"

    git_submodules_config {
      fetch_submodules = false
    }
  }

  source_version = each.value["codebuild_source_branch"] # "hello-world"

  # vpc_config {
  #   vpc_id = aws_vpc.this.id

  #   subnets = [
  #     aws_subnet.this1.id,
  #     aws_subnet.this2.id,
  #   ]

  #   security_group_ids = [
  #     aws_security_group.this1.id,
  #     aws_security_group.this2.id,
  #   ]
  # }
}
