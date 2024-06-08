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
      "Resource": [
        "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/codebuild/${each.value["codebuild_project_name"]}",
        "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/codebuild/${each.value["codebuild_project_name"]}:*"
      ]
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
      "Sid": "CodeBuildReportGroupPolicy",
      "Effect": "Allow",
      "Action": [
        "codebuild:CreateReportGroup",
        "codebuild:CreateReport",
        "codebuild:UpdateReport",
        "codebuild:BatchPutTestCases",
        "codebuild:BatchPutCodeCoverages"
      ],
      "Resource": "arn:aws:codebuild:${var.region}:${var.account_id}:report-group/${each.value["codebuild_project_name"]}-*"
    },
    {
      "Sid": "S3GetObjectPolicy",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation"
      ],
      "Resource": "*"
    },
    {
      "Sid": "S3PutObjectandBucketIdentityPolicy",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation"
      ],
      "Resource": [
        "arn:aws:s3:::${var.codebuild_s3_artifact_name}",
        "arn:aws:s3:::${var.codebuild_s3_artifact_name}/*"
      ]
    }
  ]
}
EOF
}


# # Default Trust Policy
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#           "Service": "codebuild.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }


# # Default CodeBuild Policy
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Resource": [
#         "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/codebuild/${each.value["codebuild_project_name"]}",
#         "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/codebuild/${each.value["codebuild_project_name"]}:*"
#       ],
#       "Action": [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ]
#     },
#     {
#       "Effect": "Allow",
#       "Resource": [
#         "arn:aws:s3:::codepipeline-${var.region}-*"
#       ],
#       "Action": [
#         "s3:PutObject",
#         "s3:GetObject",
#         "s3:GetObjectVersion",
#         "s3:GetBucketAcl",
#         "s3:GetBucketLocation"
#       ]
#     },
#     {
#       "Effect": "Allow",
#       "Resource": [
#         "arn:aws:s3:::${var.codebuild_s3_artifact_name}",
#         "arn:aws:s3:::${var.codebuild_s3_artifact_name}/*"
#       ],
#       "Action": [
#         "s3:PutObject",
#         "s3:GetBucketAcl",
#         "s3:GetBucketLocation"
#       ]
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "codebuild:CreateReportGroup",
#         "codebuild:CreateReport",
#         "codebuild:UpdateReport",
#         "codebuild:BatchPutTestCases",
#         "codebuild:BatchPutCodeCoverages"
#       ],
#       "Resource": [
#         "arn:aws:codebuild:${var.region}:${var.account_id}:report-group/${each.value["codebuild_project_name"]}-*"
#       ]
#     }
#   ]
# }
