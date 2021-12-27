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
  description = "SG for Instances ecoleta app Security Group"
  vpc_id      = module.vpc.vpc_id
  
  ingress {
    description      = "ecoleta app to HTTP port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["10.40.0.0/16"]
  }
  ingress {
    description      = "ecoleta app to SSH port 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.40.0.0/16"]
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
  description = "SG for Alb Security Group"
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

resource "aws_security_group" "sg_database" {
  name        = "sg_database"
  description = "Allows traffic from applications"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "app-ecoleta"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["10.40.0.0/16"]
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

# RDS Database
resource "aws_db_subnet_group" "ecoletadb_subnet" {
  name       = "ecoletadb-subnet"
  subnet_ids = ["${module.vpc.private_subnets[0]}", "${module.vpc.private_subnets[1]}", "${module.vpc.private_subnets[2]}"]
  
  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.6"
  instance_class         = "db.t3.micro"
  name                   = "nlwecoleta"
  username               = "db_user"
  password               = "Ecoleta123-2021"
  parameter_group_name   = "default.mysql5.6"
  vpc_security_group_ids = [aws_security_group.sg_database.id]
  db_subnet_group_name   = aws_db_subnet_group.ecoletadb_subnet.id
  skip_final_snapshot    = true

  tags = {
    Name = "ecoleta-rds"
  }
}

locals {
  vars = {
    db_address = aws_db_instance.default.endpoint
  }
}

#####

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

# Aplication Load Balancer
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  name = "ecoleta-alb"
  load_balancer_type = "application"

  vpc_id             = module.vpc.vpc_id
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2]]
  security_groups    = [aws_security_group.sg_alb_name.id]

  target_groups = [
    {
      name_prefix      = "tg-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 15
        path                = "/"
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
  name_prefix   = "lc-"
  image_id      = var.instance_ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.sg-instance-name.id]
  key_name      = "vockey"
  user_data = <<EOF
#!/bin/bash
## Install Docker
sudo yum update -y
sudo yum install mysql -y
sudo amazon-linux-extras install docker -y
sudo systemctl enable docker.service
sudo systemctl start docker.service
sleep 10
## Run App Ecoleta
sudo docker run --rm -p 80:8000 --name ecoleta -e HOSTDB="${aws_db_instance.default.endpoint}" -e USERDB="db_user" -e PASSDB="Ecoleta123-2021" -e SCHEDB="nlwecoleta" -d santospedroh/ecoleta:latest
EOF

  lifecycle {
    create_before_destroy = true
  }

}

# Auto Scaling
resource "aws_autoscaling_group" "asg-ecoleta" {
  name                 = "asg-ecoleta"
  launch_configuration = aws_launch_configuration.as_conf.name
  vpc_zone_identifier  = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
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
    value               = "ecoleta-app-asg"
    propagate_at_launch = true
  }

}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg-ecoleta.id
  alb_target_group_arn   = module.alb.target_group_arns[0]
}

