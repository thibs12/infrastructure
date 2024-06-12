resource "aws_cloudwatch_event_rule" "ecs_task_stopped" {
  name        = "TL-ecs-task-stopped"
  description = "Capture ECS task stopped events for Fargate tasks."
  event_pattern = jsonencode({
    "source": ["aws.ecs"],
    "detail-type": ["ECS Task State Change"],
    "detail": { 
      "clusterArn": [var.clusterArn],
      "group": ["service:app-service"],
      "lastStatus": ["STOPPED"],
      "desiredStatus": ["RUNNING"]
    }
  })
}

resource "aws_cloudwatch_event_target" "ecs_task_stopped_to_lambda" {
  rule      = aws_cloudwatch_event_rule.ecs_task_stopped.name
  target_id = "ecs_task_stopped"
  arn       = aws_lambda_function.incident_function.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_ecs_task_stopped" {
  statement_id  = "AllowExecutionFromCloudWatchECSStopped"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.incident_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ecs_task_stopped.arn
}

# Permission for CloudWatch Logs to invoke Lambda
resource "aws_lambda_permission" "allow_cloudwatch_logs" {
  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.incident_function.function_name
  principal     = "logs.amazonaws.com"
  source_arn    = var.log_group_arn
}

# Check for application errors in the log group
resource "aws_cloudwatch_log_subscription_filter" "app_error_filter" {
  name            = "app-error-filter"
  log_group_name  = var.log_group_name
  filter_pattern  = "\"fail:\""
  destination_arn = aws_lambda_function.incident_function.arn
}
