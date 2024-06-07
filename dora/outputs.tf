output "db_instance_endpoint" {
  value = aws_db_instance.rds_instance.endpoint
}

output "api_gateway_endpoint" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}