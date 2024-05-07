output "alb_hostname" {
  value = "${module.alb.alb_hostname}:${var.app_port}"
}