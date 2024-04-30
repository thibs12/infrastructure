output "target_group_arn" {
  value = aws_alb_target_group.target_app.arn
}

output "alb_hostname" {
  value = aws_alb.main_alb.dns_name
}