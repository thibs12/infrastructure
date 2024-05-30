output "main_cluster_name" {
  value = aws_ecs_cluster.main_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.app_service.name
}