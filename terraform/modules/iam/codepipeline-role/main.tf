resource "aws_iam_role" "codepipeline_execution_role" {
  for_each = var.codepipeline_execution_role
  name     = each.value["role_name"]

  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Action" = "sts:AssumeRole",
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "codepipeline.amazonaws.com"
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

resource "aws_iam_role_policy_attachment" "codepipeline_execution_policy_attachments" {
  for_each   = var.codepipeline_execution_role
  policy_arn = aws_iam_policy.codepipeline_execution_policy[each.key].arn
  role       = aws_iam_role.codepipeline_execution_role[each.key].name
}

resource "aws_iam_policy" "codepipeline_execution_policy" {
  for_each = var.codepipeline_execution_policy
  name     = each.value["policy_name"]

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codecommit:CancelUploadArchive",
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:GetUploadArchiveStatus",
        "codecommit:UploadArchive"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:CreateDeployment",
        "codedeploy:GetApplicationRevision",
        "codedeploy:GetDeployment",
        "codedeploy:GetDeploymentConfig",
        "codedeploy:RegisterApplicationRevision"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "lambda:InvokeFunction",
        "lambda:ListFunctions"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": "*",
      "Condition": {
        "StringEqualsIfExists": {
            "iam:PassedToService": [
                "codecommit.amazonaws.com",
                "codebuild.amazonaws.com",
                "codedeploy.amazonaws.com",
                "lambda.amazonaws.com"
            ]
        }
      }
    }
  ]
}
EOF
}
