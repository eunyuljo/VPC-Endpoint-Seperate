resource "aws_instance" "test_ec2_a" {
  ami                         = "ami-0023481579962abd4" # 최신 Amazon Linux 2 AMI (서울 리전)
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.service_a_private_az_a.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_profile.name
  associate_public_ip_address = false # 퍼블릭 IP 없이 운영

  tags = {
    Name = "Test-EC2-Service-A"
  }
}

resource "aws_instance" "test_ec2_b" {
  ami                         = "ami-0023481579962abd4" # 최신 Amazon Linux 2 AMI (서울 리전)
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.service_b_private_az_a.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_profile.name
  associate_public_ip_address = false # 퍼블릭 IP 없이 운영

  tags = {
    Name = "Test-EC2-Service-B"
  }
}

# 🔹 EC2용 보안 그룹 (ECR, SSM 등 접근 허용)
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # 같은 VPC 내에서만 접근 가능
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # 모든 프로토콜 허용
    cidr_blocks = ["0.0.0.0/0"] # 모든 대상 허용 (필요 시 더 제한 가능)
  }

  tags = {
    Name = "ec2-sg"
  }
}


resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "EC2SSMProfile"
  role = aws_iam_role.ec2_ssm_role.name
}


# EC2용 IAM Role 생성
resource "aws_iam_role" "ec2_ssm_role" {
  name = "EC2SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}