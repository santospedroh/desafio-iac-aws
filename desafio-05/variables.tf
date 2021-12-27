# Input variable definitions
variable "vpc_name" {
  description = "Application VPC"
  type        = string
  default     = "app-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.40.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.40.10.0/24", "10.40.20.0/24", "10.40.30.0/24"]
}

variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["10.40.40.0/24", "10.40.50.0/24", "10.40.60.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for VPC"
  type        = bool
  default     = true
}

variable "vpc_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default = {
    Terraform = "true"
    Environment = "production"
  }
}

variable "sg-instance-name" {
  description = "Snake of SG HTTP"
  type        = string
  default     = "instances-sg"
}

variable "sg_alb_name" {
  description = "Alb of SG HTTP"
  type        = string
  default     = "alb-sg"
}

variable "sg_tags" {
  description = "Tags to apply to resources created by Security Group module"
  type        = map(string)
  default = {
    Terraform = "true"
    Environment = "production"
  }
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "instance_jump_type" {
    type = string
    default = "t2.micro"
}

variable "instance_name" {
    type = string
    default = "ecoleta-app"
}

variable "instance_jump_name" {
    type = string
    default = "jump"
}

variable "instance_ami" {
    type = string
    default = "ami-04902260ca3d33422"
}

variable "instance_tags" {
  description = "Tags to apply to resources created by Instances module"
  type        = map(string)
  default = {
    Name = "ecoleta-app-asg"
    Terraform = "true"
    Environment = "production"
    Team = "engenharia"
    Application = "ecoleta"
    BU = "nodejs"

  }
}
