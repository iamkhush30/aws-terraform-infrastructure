# Dynamic AMI Data Source (Fetches latest Ubuntu AMI for ap-south-1)
data "aws_ami" "ubuntu" {
  owners      = ["099720109477"] # Canonical
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Key Pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "km-cloud-key"
  public_key = file("${path.module}/khush-key.pub")
}

# Default VPC
resource "aws_default_vpc" "default" {}

# Security Group
resource "aws_security_group" "my_security_group" {
  name        = "km-cloud-security-group"
  vpc_id      = aws_default_vpc.default.id
  description = "Inbound and outbound rules for km-cloud instances"

  tags = {
    Name = "km-cloud-security-group"
  }
}

# Inbound & Outbound rules
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # all protocols and ports
}

# EC2 Instances (Free Tier: 1 instance)
resource "aws_instance" "my_instance" {
  count = var.instance_count

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name               = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  user_data              = file("${path.module}/script.sh")

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = "km-cloud-server-${count.index}"
  }
}
