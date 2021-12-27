output "alb_dns" {
  description = "DNS of the Application Load Balancer"
  value = module.alb.lb_dns_name
}

