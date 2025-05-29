# Use default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group for ECS tasks
resource "aws_security_group" "retail_sg" {
  name        = "retail-public-sg"
  description = "Allow OTLP, HTTP, and UI from anywhere"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow OTLP HTTP traffic"
    from_port   = 4318
    to_port     = 4318
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow custom UI traffic"
    from_port   = 12345
    to_port     = 12345
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP traffic to ECS containers"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "retail-public-sg"
  }
}
