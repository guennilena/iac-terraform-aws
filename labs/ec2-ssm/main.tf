data "aws_caller_identity" "current" {}

moved {
  from = aws_security_group.ec2
  to   = aws_security_group.main
}

data "aws_ami" "al2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# --- Networking (minimal VPC with 1 public subnet) ---
resource "aws_vpc" "this" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.name_prefix}-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.20.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "${var.name_prefix}-public-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.name_prefix}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security group: no inbound needed for SSM
resource "aws_security_group" "main" {
  name        = "${var.name_prefix}-sg"
  description = "No inbound; outbound allowed for SSM"
  vpc_id      = aws_vpc.this.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg"
  }

  lifecycle {
    ignore_changes = [tags]
  }

}

# --- IAM Role for EC2 + SSM ---
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2" {
  name               = "${var.name_prefix}-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# Enables SSM Session Manager
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Optional: demonstrate role-based access to S3 list (uncomment if you want)
# resource "aws_iam_role_policy_attachment" "s3_read" {
#   role       = aws_iam_role.ec2.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
# }

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.name_prefix}-instance-profile"
  role = aws_iam_role.ec2.name
}

# --- EC2 instance ---
resource "aws_instance" "this" {
  ami                         = data.aws_ami.al2.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.main.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2.name
  associate_public_ip_address = true

  # Ensure SSM Agent is running (Amazon Linux 2 typically has it; we start/enable anyway)
  user_data = <<-EOF
              #!/bin/bash
              set -e
              yum update -y
              systemctl enable amazon-ssm-agent
              systemctl restart amazon-ssm-agent
              EOF

  tags = {
    Name = "${var.name_prefix}-instance"
  }
}
