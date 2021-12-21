output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}

output "ec2_instance_1_public_ips" {
  description = "Public IP addresses of EC2 instance 1"
  value       = module.ec2_instance_1.public_ip
}

output "ec2_instance_2_public_ips" {
  description = "Public IP addresses of EC2 instance 2"
  value       = module.ec2_instance_2.public_ip
}