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

resource "aws_security_group" "game_snake_sg" {
  name        = "snake-sg"
  description = "SG for Instances Snake Security Group"
  vpc_id      = module.vpc.vpc_id
  
  ingress {
    description      = "Game Snake port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "http"
    cidr_blocks      = ["10.200.0.0/16"]
  }
  ingress {
    description      = "Game Snake port 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.200.0.0/16"]
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

resource "aws_security_group" "alb_snake_sg" {
  name        = "alb-snake-sg"
  description = "SG for Alb Snake Security Group"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description      = "Alb port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "http"
    cidr_blocks      = ["10.200.101.0/24"]
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

module "ec2_instance_1" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name          = "${var.instance_name}-1"

  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = "vockey"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.game_snake_sg.id]
  subnet_id              = module.vpc.private_subnets[0]
  user_data     = file("./src/userdata.sh")

  tags = var.instance_tags
}

module "ec2_instance_2" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name          = "${var.instance_name}-2"

  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = "vockey"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.game_snake_sg.id]
  subnet_id              = module.vpc.private_subnets[1]
  user_data     = file("./src/userdata.sh")

  tags = var.instance_tags
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"

  name = "snake-alb"

  load_balancer_type = "application"

  vpc_id             = module.vpc.vpc_id
  subnets            = [module.vpc.public_subnets[0]]
  security_groups    = [aws_security_group.alb_snake_sg.id]

  target_groups = [
    {
      name_prefix      = "snake-"
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
          target_id = module.ec2_instance_1.id
          port = 80
        },
        {
          target_id = module.ec2_instance_2.id
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