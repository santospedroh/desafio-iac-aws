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

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["0", "1"])

  name                   = "${var.instance_name}-${each.key}"
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = "vockey"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.sg-instance-name.id]
  subnet_id              = module.vpc.private_subnets[each.key]
  user_data     = file("./src/flappy-bird.sh")

  tags = var.instance_tags
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
      targets = [
        {
          target_id = module.ec2_instance[0].id
          port = 80
        },
        {
          target_id = module.ec2_instance[1].id
          port = 80
        }
      ]
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
  availability_zones   = [module.vpc.private_subnets[0].id, module.vpc.private_subnets[1].id]
  min_size             = 1
  max_size             = 2

  lifecycle {
    create_before_destroy = true
  }
}

