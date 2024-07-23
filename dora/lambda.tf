resource "aws_security_group" "lambda_sg" {
  vpc_id = data.terraform_remote_state.app.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "DORA-lambda-sg"
  })
}

resource "aws_lambda_function" "commit_function" {
  filename         = "${path.module}/python/lambda_commit.zip"
  function_name    = "DORA-commitFunction"
  role             = aws_iam_role.lambda_commit_role.arn
  handler          = "lambda_commit.lambda_handler"
  runtime          = "python3.10"
  source_code_hash = filebase64sha256("${path.module}/python/lambda_commit.zip")
  tags = merge(var.tags, {
    Name = "DORA-commitFunction"
  })

  vpc_config {
    subnet_ids         = [aws_subnet.private_db_subnet_az1.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      DATABASE_ENDPOINT = var.db_endpoint
      DATABASE_NAME     = var.db_name
      DATABASE_USER     = var.db_username
      DATABASE_PASSWORD = var.db_password
    }
  }
}

resource "aws_lambda_function" "deploy_function" {
  filename         = "${path.module}/python/lambda_deployment.zip"
  function_name    = "DORA-deployFunction"
  role             = aws_iam_role.lambda_deploy_role.arn
  handler          = "lambda_deployment.lambda_handler"
  runtime          = "python3.10"
  source_code_hash = filebase64sha256("${path.module}/python/lambda_deployment.zip")
  timeout          = 600
  tags = merge(var.tags, {
    Name = "DORA-deployFunction"
  })

  vpc_config {
    subnet_ids         = [aws_subnet.private_db_subnet_az1.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      DATABASE_ENDPOINT = var.db_endpoint
      DATABASE_NAME     = var.db_name
      DATABASE_USER     = var.db_username
      DATABASE_PASSWORD = var.db_password
      CLUSTER_ARN       = var.clusterArn
      SERVICE_NAME      = var.service_name
    }
  }
}

resource "aws_lambda_function" "incident_function" {
  filename         = "${path.module}/python/lambda_incident.zip"
  function_name    = "DORA-incidentFunction"
  role             = aws_iam_role.lambda_incident_role.arn
  handler          = "lambda_incident.lambda_handler"
  runtime          = "python3.10"
  source_code_hash = filebase64sha256("${path.module}/python/lambda_incident.zip")
  tags = merge(var.tags, {
    Name = "DORA-incidentFunction"
  })

  vpc_config {
    subnet_ids         = [aws_subnet.private_db_subnet_az1.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      DATABASE_ENDPOINT = var.db_endpoint
      DATABASE_NAME     = var.db_name
      DATABASE_USER     = var.db_username
      DATABASE_PASSWORD = var.db_password
    }
  }
}
