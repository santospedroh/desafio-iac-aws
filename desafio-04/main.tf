# VPC - Subnet - Network
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

# Security Group
resource "aws_security_group" "sg-instance-name" {
  name        = var.sg-instance-name
  description = "SG for Instances Flappy Bird Security Group"
  vpc_id      = module.vpc.vpc_id
  
  ingress {
    description      = "Flappy Bird to HTTP port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["10.30.0.0/16"]
  }
  ingress {
    description      = "Flappy Bird to SSH port 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.30.0.0/16"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.sg_tags
}

resource "aws_security_group" "jump_sg" {
  name        = "jump-sg"
  description = "SG for Instances Jump Security Group"
  vpc_id      = module.vpc.vpc_id
  
  ingress {
    description      = "SSH port 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.sg_tags
}

resource "aws_security_group" "sg_alb_name" {
  name        = var.sg_alb_name
  description = "SG for Alb Snake Security Group"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description      = "Alb port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.sg_tags
}

# Instancias EC2
module "ec2_jump" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name                   = "${var.instance_jump_name}"
  ami                    = var.instance_ami
  instance_type          = var.instance_jump_type
  key_name               = "vockey"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.jump_sg.id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
        Name = "jump"
    }
}

#Aplication Load Balancer
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  name = "flappy-bird-alb"
  load_balancer_type = "application"

  vpc_id             = module.vpc.vpc_id
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  security_groups    = [aws_security_group.sg_alb_name.id]

  target_groups = [
    {
      name_prefix      = "tg-fb-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 15
        path                = "/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = var.sg_tags
}

# Launch Configuration
resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "lc-fb-"
  image_id      = var.instance_ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.sg-instance-name.id]
  key_name      = "vockey"
  user_data     = file("./src/flappy-bird.sh")

  lifecycle {
    create_before_destroy = true
  }

}

# Auto Scaling
resource "aws_autoscaling_group" "asg-flappy-bird" {
  name                 = "asg-flappy-bird"
  launch_configuration = aws_launch_configuration.as_conf.name
  vpc_zone_identifier  = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  health_check_grace_period = 90
  health_check_type    = "ELB"
  force_delete         = true
  desired_capacity     = 2
  min_size             = 2
  max_size             = 3

  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "flappy-bird-asg"
    propagate_at_launch = true
  }

}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg-flappy-bird.id
  alb_target_group_arn   = module.alb.target_group_arns[0]
}

