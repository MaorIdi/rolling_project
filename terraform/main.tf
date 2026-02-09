###########################
# 1. Generate SSH Key Pair
###########################

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/builder_key.pem"
  file_permission = "0600"
}

resource "aws_key_pair" "builder_key" {
  key_name   = "builder_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

##############################
# 2. Security Group
##############################

resource "aws_security_group" "builder_sg" {
  name        = "maor-sg-builder"
  description = "Security group for builder instance"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "HTTP Access for Python app"
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "Port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "builder-sg"
  }
}

##################################
# 3. Find a Public Subnet in VPC
##################################

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  # assuming at least one subnet is public — you can adjust if you have tagging
}

##################################
# 4. Create EC2 Instance
##################################

resource "aws_instance" "builder" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.builder_sg.id]
  key_name                    = aws_key_pair.builder_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "builder"
  }
}
