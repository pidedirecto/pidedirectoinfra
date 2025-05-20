resource "aws_security_group" "alloy_sg" {
  name        = "alloy-public-sg"
  description = "Allow OTLP HTTP and UI from anywhere"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "alloy-public-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_otlp_http" {
  security_group_id = aws_security_group.alloy_sg.id
  ip_protocol       = "tcp"
  from_port         = 4318
  to_port           = 4318
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "allow_otlp_http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_alloy_ui" {
  security_group_id = aws_security_group.alloy_sg.id
  ip_protocol       = "tcp"
  from_port         = 12345
  to_port           = 12345
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "allow_alloy_ui"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.alloy_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "allow_all_outbound"
  }
}

# use default VPC
data "aws_vpc" "default" {
  default = true
}


data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}