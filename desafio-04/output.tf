output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}

output "instances" {
  description = "IDs of the Instances"
  value = module.ec2_instance.*.id
}

output "alb_dns" {
  description = "DNS of the Application Load Balancer"
  value = module.alb.lb_dns_name
}

