output "jump_ip" {
    description = "Public IP Jump Instance  "
    value = module.ec2_jump.public_ip
}
output "alb_dns" {
  description = "DNS of the Application Load Balancer"
  value = module.alb.lb_dns_name
}

