# EXECUTION TASK ROLE FOR ECS
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.ecs_task_name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = var.tags
}

resource "aws_iam_role_policy" "ecs_task_execution_role_inline_policy" {
  name = "get_secret_policy_for_docker_credentials"
  role = aws_iam_role.ecs_task_execution_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          "arn:aws:secretsmanager:eu-west-1:891377364444:secret:docker_credentials-XgV9MJ"
        ]
      }
    ]
  })
}


data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# TASK ROLE FOR ECS
resource "aws_iam_role" "ecs_task_role" {
  name = "limited-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "ecs_task_role_policy" {
  name = "exec-command-needed-policy"
  role = aws_iam_role.ecs_task_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        Resource = [
          "*"
        ]
      }
    ]
  })
}

# ROLE FOR GITHUB TO ACCESS ECS AND INVOKE LAMBDA
resource "aws_iam_role" "github_ecs_role" {
  name = "limited-github-access-ecs"
  assume_role_policy = data.aws_iam_policy_document.assume_role_web_identity.json
}

data "aws_iam_policy_document" "assume_role_web_identity" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::891377364444:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:thibs12/todolist:*"]
    }
  }
}

resource "aws_iam_role_policy" "invoke_lambda_policy" {
  name = "TL-AllowInvokeFunction"
  role = aws_iam_role.github_ecs_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "lambda:InvokeFunction",
        Resource = "arn:aws:lambda:eu-west-1:891377364444:function:TL-deployFunction"
        
      }
    ]
  })
}

#Attach amazon policy AmazonECS_FullAccess
resource "aws_iam_role_policy_attachment" "ecs_github_policy" {
  role       = aws_iam_role.github_ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

# ROLE FOR GITHUB TO DEPLOY TERRAFORM
resource "aws_iam_role" "github_terraform_role" {
  name = "limited-github-access-terraform"
  assume_role_policy = data.aws_iam_policy_document.assume_role_web_identity_terraform.json
}

resource "aws_iam_role_policy_attachment" "terraform_github_policy" {
  role       = aws_iam_role.github_terraform_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy_document" "assume_role_web_identity_terraform" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::891377364444:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:thibs12/infrastructure:*"]
    }
  }
}




