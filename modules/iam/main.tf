resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.ecs_task_name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  
}

resource "aws_iam_role_policy" "ecs_task_execution_role_inline_policy" {
  name   = "get_secret_policy_for_docker_credentials"
  role   = aws_iam_role.ecs_task_execution_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
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
