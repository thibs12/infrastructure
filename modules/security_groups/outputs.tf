output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
  description = "ID of ALB security group"
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
  description = "ID of ECS security group"
}