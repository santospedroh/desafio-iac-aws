# Create a VPC
resource "aws_vpc" "mackenzie_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    Name = "mackenzie-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "mackenzie_gw" {
  vpc_id = aws_vpc.mackenzie_vpc.id
  tags = {
    Name = "mackenzie_gw"
  }
}

# Create Subnet Public
resource "aws_subnet" "mackenzie_subnet" {
  vpc_id            = aws_vpc.mackenzie_vpc.id
  cidr_block        = "10.0.0.0/24"
  tags = {
    Name = "mackenzie-subnet-public"
  }
}

# Create Route table
resource "aws_route_table" "mackenzie_rt" {
  vpc_id = aws_vpc.mackenzie_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mackenzie_gw.id
  }
  tags = {
    Name = "mackenzie-rt-public"
  }
}
# Route table association with public subnets
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.mackenzie_subnet.id
  route_table_id = aws_route_table.mackenzie_rt.id
}

# Create Security Group
variable "sg_ports" {
    type = list(number)
    description = "Lista com as portas para o ingress do sg"
    default = [80, 443, 22]
}
resource "aws_security_group" "mackenzie_sg" {
  name        = "mackenzie_sg"
  description = "SG desafio via Terraform"
  vpc_id      = aws_vpc.mackenzie_vpc.id
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
    Name = "mackenzie-sg"
  }
}

# Create Instance
resource "aws_instance" "mackenzie_ec2" {
  ami           = "ami-04902260ca3d33422"
  instance_type = "t3.medium"
  key_name      = "vockey"
  subnet_id     = aws_subnet.mackenzie_subnet.id
  vpc_security_group_ids = [aws_security_group.mackenzie_sg.id]
  associate_public_ip_address = "true"
  tags = {
    Name       = "ec2-iac",
    Ambiente   = "dev",
    Time       = "mackenzie"
    Applicacao = "frontend"
    BU         = "conta-digital"
  }
  provisioner "file" {
    source      = "./src/groovin.zip"
    destination = "/tmp/groovin.zip"
  }
  provisioner "file" {
    source      = "./src/script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh"
    ]
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./src/labsuser.pem")
    host        = self.public_ip
  }
}

output "info_ec2_arn" {
    value = aws_instance.mackenzie_ec2.arn
}
output "info_ec2_public_ip" {
    value = aws_instance.mackenzie_ec2.public_ip
}
output "info_ec2_public_dns" {
    value = aws_instance.mackenzie_ec2.public_dns 
}

