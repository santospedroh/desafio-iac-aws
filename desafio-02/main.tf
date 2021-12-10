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

# Create Subnet Public AZ us-east-1a
resource "aws_subnet" "app_subnet_1a" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.100.10.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "app-subnet-public-1a"
  }
}

# Create Subnet Public AZ us-east-1c
resource "aws_subnet" "app_subnet_1c" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.100.30.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "app-subnet-public-1c"
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

# Route table association with public subnet a
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.app_subnet_1a.id
  route_table_id = aws_route_table.app_rt.id
}

# Route table association with public subnet a
resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.app_subnet_1c.id
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
resource "aws_instance" "app_ec2_01" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "vockey"
  subnet_id     = aws_subnet.app_subnet_1a.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  associate_public_ip_address = "true"
  user_data     = file("./src/userdata.sh")
  tags = {
    Name       = "${var.instance_name}-01"
    Ambiente   = "Sandbox"
    Time       = "Mackenzie"
    Applicacao = "Post-it"
    BU         = "Python"
  }
}

resource "aws_instance" "app_ec2_02" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "vockey"
  subnet_id     = aws_subnet.app_subnet_1c.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  associate_public_ip_address = "true"
  user_data     = file("./src/userdata.sh")
  tags = {
    Name       = "${var.instance_name}-02"
    Ambiente   = "Sandbox"
    Time       = "Mackenzie"
    Applicacao = "Post-it"
    BU         = "Python"
  }
}

# Print Instace post-it-app-01
output "info_app_ec2_01_arn" {
    value = aws_instance.app_ec2_01.arn
}
output "info_app_ec2_01_public_ip" {
    value = aws_instance.app_ec2_01.public_ip
}
output "info_app_ec2_01_public_dns" {
    value = aws_instance.app_ec2_01.public_dns 
}

# Print Instace post-it-app-02
output "info_app_ec2_02_arn" {
    value = aws_instance.app_ec2_02.arn
}
output "info_app_ec2_02_public_ip" {
    value = aws_instance.app_ec2_02.public_ip
}
output "info_app_ec2_02_public_dns" {
    value = aws_instance.app_ec2_02.public_dns 
}
