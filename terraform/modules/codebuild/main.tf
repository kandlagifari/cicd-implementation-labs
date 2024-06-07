resource "aws_codebuild_project" "this" {
  for_each = var.codebuild_project_details
  name          = each.value["codebuild_name"]
  description   = each.value["codebuild_description"]
  build_timeout = each.value["codebuild_timeout"]
  service_role  = each.value["codebuild_role"]

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.this.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "SOME_KEY1"
      value = "SOME_VALUE1"
    }

    environment_variable {
      name  = "SOME_KEY2"
      value = "SOME_VALUE2"
      type  = "PARAMETER_STORE"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.this.id}/build-log"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/mitchellh/packer.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "master"

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
