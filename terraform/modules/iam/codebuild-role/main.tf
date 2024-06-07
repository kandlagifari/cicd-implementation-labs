resource "aws_iam_role" "codebuild_execution_role" {
  for_each = var.codebuild_execution_role
  name     = each.value["role_name"]

  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Action" = "sts:AssumeRole",
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "codebuild.amazonaws.com"
        }
        "Condition" = {
          "StringEquals" = {
            "aws:SourceAccount" = var.account_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_execution_policy_attachments" {
  for_each   = var.codebuild_execution_role
  policy_arn = aws_iam_policy.codebuild_execution_policy[each.key].arn
  role       = aws_iam_role.codebuild_execution_role[each.key].name
}

resource "aws_iam_policy" "codebuild_execution_policy" {
  for_each = var.codebuild_execution_policy
  name     = each.value["policy_name"]

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CloudWatchLogsPolicy",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CodeCommitPolicy",
      "Effect": "Allow",
      "Action": [
        "codecommit:GitPull"
      ],
      "Resource": "*"
    },
    {
      "Sid": "S3GetObjectPolicy",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ],
      "Resource": "*"
    },
    {
      "Sid": "S3PutObjectPolicy",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "*"
    },
    {
      "Sid": "S3BucketIdentity",
      "Effect": "Allow",
      "Action": [
        "s3:GetBucketAcl",
        "s3:GetBucketLocation"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
