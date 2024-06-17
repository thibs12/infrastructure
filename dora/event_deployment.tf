resource "aws_cloudwatch_event_rule" "ecs_new_deployment" {
  name        = "TL-ecs-new-deployment"
  description = "Capture ECS task state change events for Fargate tasks."
  event_pattern = jsonencode({
    "source" : ["aws.ecs"],
    "detail-type" : ["ECS Task State Change"],
    "detail" : {
      "clusterArn" : [var.clusterArn],
      "group" : ["service:app-service"],
      "lastStatus" : ["RUNNING"],
      "healthStatus" : ["HEALTHY"]
    }
  })
}

resource "aws_cloudwatch_event_target" "send_to_lambda" {
  rule      = aws_cloudwatch_event_rule.ecs_new_deployment.name
  target_id = "send_to_lambda"
  arn       = aws_lambda_function.deploy_function.arn
}

