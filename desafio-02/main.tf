# Create a VPC
resource "aws_vpc" "app_vpc" {
  cidr_block = "10.100.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    Name = "app_vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "app_gw" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "app_gw"
  }
}

# Create Subnet Public
resource "aws_subnet" "app_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.100.0.0/24"
  tags = {
    Name = "app-subnet-public"
  }
}

# Create Route table
resource "aws_route_table" "app_rt" {
  vpc_id = aws_vpc.app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_gw.id
  }
  tags = {
    Name = "app-rt-public"
  }
}
# Route table association with public subnets
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.app_rt.id
}

# Create Security Group
resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "SG desafio-02 via Terraform"
  vpc_id      = aws_vpc.app_vpc.id
  dynamic "ingress" {
    for_each = var.sg_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "egress" {
    for_each = var.sg_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    Name = "app_sg"
  }
}

# Create Instance
resource "aws_instance" "app_ec2" {
  count = 2
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "vockey"
  subnet_id     = aws_subnet.app_subnet.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  associate_public_ip_address = "true"
  user_data     = file("./src/userdata.sh")
  tags = {
    Name       = "${var.instance_name}-${count.index}"
    Ambiente   = "Sandbox"
    Time       = "Mackenzie"
    Applicacao = "Post-it"
    BU         = "Python"
  }
}

# Print Instace post-it-app-0
output "info_ec20_arn" {
    value = aws_instance.app_ec2[0].arn
}
output "info_ec20_public_ip" {
    value = aws_instance.app_ec2[0].public_ip
}
output "info_ec20_public_dns" {
    value = aws_instance.app_ec2[0].public_dns 
}

# Print Instace post-it-app-1
output "info_ec21_arn" {
    value = aws_instance.app_ec2[1].arn
}
output "info_ec21_public_ip" {
    value = aws_instance.app_ec2[1].public_ip
}
output "info_ec21_public_dns" {
    value = aws_instance.app_ec2[1].public_dns 
}
