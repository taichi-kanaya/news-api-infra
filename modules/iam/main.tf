data "aws_caller_identity" "current" {}

# GitHub Actions用IAMロール
resource "aws_iam_role" "oidc_github_actions" {
  name = "CustomOIDCGithubActionsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          },
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : "repo:taichi-kanaya/${var.ecr_repository_name}:*"
          }
        }
      }
    ]
  })
}

# ECRにDockerイメージをPushするためのIAMポリシー
resource "aws_iam_policy" "ecr_put_image" {
  name = "CustomECRPutImagePolicy"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "ecr:GetAuthorizationToken",
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "ecr:BatchCheckLayerAvailability",
            "ecr:CompleteLayerUpload",
            "ecr:InitiateLayerUpload",
            "ecr:PutImage",
            "ecr:UploadLayerPart"
          ],
          "Resource" : "arn:aws:ecr:ap-northeast-1:${data.aws_caller_identity.current.account_id}:repository/${var.ecr_repository_name}"
        }
      ]
    }
  )
}
resource "aws_iam_policy_attachment" "oidc_github_actions" {
  name       = "OIDCGithubActionsAttachment"
  roles      = [aws_iam_role.oidc_github_actions.name]
  policy_arn = aws_iam_policy.ecr_put_image.arn
}

# ECSタスク実行ロール用IAMロール
resource "aws_iam_role" "ecs_task_execution" {
  name = "CustomECSTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# ECSタスク実行ロール用IAMポリシー
resource "aws_iam_policy" "ecs_task_execution" {
  name = "CustomECSTaskExecutionPolicy"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameters",
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}
resource "aws_iam_policy_attachment" "ecs_task_execution" {
  name       = "OIDCGithubActionsAttachment"
  roles      = [aws_iam_role.ecs_task_execution.name]
  policy_arn = aws_iam_policy.ecs_task_execution.arn
}
