resource "aws_appautoscaling_target" "target" {
  max_capacity       = 6
  min_capacity       = 2
  resource_id        = var.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "up" {
    name               = "scale_up"
    resource_id        = aws_appautoscaling_target.target.resource_id
    scalable_dimension = aws_appautoscaling_target.target.scalable_dimension
    service_namespace  = aws_appautoscaling_target.target.service_namespace
    
    step_scaling_policy_configuration {
        adjustment_type         = "ChangeInCapacity"
        cooldown                = 60
        metric_aggregation_type = "Maximum"
        step_adjustment {
        metric_interval_lower_bound = 0
        scaling_adjustment          = 1
        }
    }
}

resource "aws_appautoscaling_policy" "down" {
    name               = "scale_down"
    resource_id        = aws_appautoscaling_target.target.resource_id
    scalable_dimension = aws_appautoscaling_target.target.scalable_dimension
    service_namespace  = aws_appautoscaling_target.target.service_namespace
    
    step_scaling_policy_configuration {
        adjustment_type         = "ChangeInCapacity"
        cooldown                = 60
        metric_aggregation_type = "Maximum"
        step_adjustment {
        metric_interval_upper_bound = 0
        scaling_adjustment          = -1
        }
    }
}

# Cloudwatch alarm for scaling up
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
    alarm_name          = "cpu_utilization_high"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 2
    metric_name         = "CPUUtilization"
    namespace           = "AWS/ECS"
    period              = 60
    statistic           = "Average"
    threshold           = 85
    alarm_description   = "This will scale up the ECS service"
    alarm_actions       = [aws_appautoscaling_policy.up.arn]
    dimensions = {
        ClusterName = var.cluster_name
        ServiceName = var.ecs_service_name
    }
}

# Cloudwatch alarm for scaling down
resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
    alarm_name          = "cpu_utilization_low"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods  = 2
    metric_name         = "CPUUtilization"
    namespace           = "AWS/ECS"
    period              = 60
    statistic           = "Average"
    threshold           = 10
    alarm_description   = "This will scale down the ECS service"
    alarm_actions       = [aws_appautoscaling_policy.down.arn]
    dimensions = {
        ClusterName = var.cluster_name
        ServiceName = var.ecs_service_name
    }
}