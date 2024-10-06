# Provider configuration for AWS
provider "aws" {
  region = "eu-west-2" # Change to your preferred region
}

# Security group to allow inbound SSH and portal app traffic
resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  description = "Security group for frontend EC2"

  # Inbound Rules
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow from all IPs
  }

  ingress {
    description = "Allow portal app"
    from_port   = 5173
    to_port     = 5173
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow from all IPs
  }

  # Outbound Rules (no restrictions)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "frontend-sg"
  }
}

# Create EC2 instance
resource "aws_instance" "frontend" {
  ami           ="ami-0b45ae66668865cd6"  # Amazon Linux 2 AMI (Change to your preferred AMI)
  instance_type = "t2.micro"               # Free-tier eligible instance

  # Attach the security group
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]

  tags = {
    Name = "frontend"
  }

  # Key pair for SSH (Ensure you have created a key pair in AWS)
  key_name = "NodeA"  # Replace with your AWS key pair name
}

# Output the public IP of the EC2 instance
output "instance_public_ip" {
  description = "The public IP of the frontend EC2 instance"
  value       = aws_instance.frontend.public_ip
}
