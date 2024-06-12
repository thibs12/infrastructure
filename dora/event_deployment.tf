resource "aws_cloudwatch_event_rule" "ecs_new_deployment" {
  name        = "TL-ecs-deployment-completed"
  description = "Capture ECS service action events when the service reaches TASKSET_STEADY_STATE."
  event_pattern = jsonencode({
    "source": ["aws.ecs"],
    "detail-type": ["ECS Service Action"],
    "detail": {
      "eventName": ["TASKSET_STEADY_STATE"],
      "clusterArn": [var.clusterArn],
      "serviceName": [var.service_name]
    }
  })
}

resource "aws_cloudwatch_event_target" "send_to_lambda" {
  rule      = aws_cloudwatch_event_rule.ecs_new_deployment.name
  target_id = "send_to_lambda"
  arn       = aws_lambda_function.deploy_function.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.deploy_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ecs_new_deployment.arn
}