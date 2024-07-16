resource "aws_iam_role" "lambda_commit_role" {
  name = "limited-TL-lambda-commit-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role" "lambda_deploy_role" {
  name = "limited-TL-lambda-deploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role" "lambda_incident_role" {
  name = "limited-TL-lambda-incident-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_policy" "TL-lambda_logs_policy" {
  name        = "TL-lambda-logs-policy"
  description = "Policy to allow logs actions"
  tags = var.tags
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "logs:FilterLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach the logs policy to the roles
resource "aws_iam_policy_attachment" "attach_logs_policy" {
  name       = "TL-attach-lambda-policy-logs"
  roles      = [aws_iam_role.lambda_commit_role.name, aws_iam_role.lambda_deploy_role.name, aws_iam_role.lambda_incident_role.name]
  policy_arn = aws_iam_policy.TL-lambda_logs_policy.arn
}

# Attach the VPC policy to the roles
resource "aws_iam_policy_attachment" "attach_vpc_policy" {
  name       = "TL-attach-lambda-policy-vpc"
  roles      = [aws_iam_role.lambda_commit_role.name, aws_iam_role.lambda_deploy_role.name, aws_iam_role.lambda_incident_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Permissions pour la fonction déploiement
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.deploy_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ecs_new_deployment.arn
}

resource "aws_iam_policy" "ecs_policy" {
  name        = "TL-ecs-access-policy"
  description = "Policy to allow ECS actions"
  tags = var.tags
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:ListTasks",
          "ecs:DescribeTasks"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment" {
  role       = aws_iam_role.lambda_deploy_role.name
  policy_arn = aws_iam_policy.ecs_policy.arn
}

# Permissions pour la fonction incident
resource "aws_lambda_permission" "allow_cloudwatch_ecs_task_stopped" {
  statement_id  = "AllowExecutionFromCloudWatchECSStopped"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.incident_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ecs_task_stopped.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_logs" {
  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.incident_function.function_name
  principal     = "logs.amazonaws.com"
  source_arn    = var.log_group_arn
}