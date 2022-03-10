terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  profile = var.aws_profile
  region = var.aws_region
  assume_role {
    role_arn = var.role_arn
  }
}

resource "aws_iam_policy" "policy_GH_Upload_To_S3" {
  name = "GH-Upload-To-S3"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucketVersions",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::codedeploy.huayi0119.me/*",
          "arn:aws:s3:::codedeploy.huayi0119.me"
        ]
      }
    ]
  })
}


resource "aws_iam_policy" "policy_GH_Code_Deploy" {
  name = "GH-Code-Deploy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codedeploy:RegisterApplicationRevision",
          "codedeploy:GetApplicationRevision"
        ],
        Resource = [
          "arn:aws:codedeploy:us-east-1:${var.acc_id}:application:${var.app_name}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "codedeploy:CreateDeployment",
          "codedeploy:GetDeployment"
        ],
        Resource = [
          "arn:aws:codedeploy:us-east-1:${var.acc_id}:deploymentgroup:${var.app_name}/${var.group_name}",
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "codedeploy:GetDeploymentConfig"
        ],
        Resource = [
          "arn:aws:codedeploy:us-east-1:${var.acc_id}:deploymentconfig:CodeDeployDefault.OneAtATime",
          "arn:aws:codedeploy:us-east-1:${var.acc_id}:deploymentconfig:CodeDeployDefault.HalfAtATime",
          "arn:aws:codedeploy:us-east-1:${var.acc_id}:deploymentconfig:CodeDeployDefault.AllAtOnce"
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "role_policy_attach2" {
  user = "ghactions-app"
  policy_arn = aws_iam_policy.policy_GH_Upload_To_S3.arn
}

resource "aws_iam_user_policy_attachment" "role_policy_attach3" {
  user = "ghactions-app"
  policy_arn = aws_iam_policy.policy_GH_Code_Deploy.arn
}