resource "aws_security_group" "db" {
  name        = "${var.project_name}-db-sg-${local.name_suffix}"
  description = "Allow PostgreSQL within VPC"
  vpc_id      = aws_vpc.this.id

  # egress offen ist ok für RDS (Updates/Telemetry); inbound ist restriktiv
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-db-sg" }
}

# Inbound nur aus der VPC auf 5432 (für später: Lambda/EC2 im VPC)
resource "aws_vpc_security_group_ingress_rule" "postgres_from_vpc" {
  security_group_id = aws_security_group.db.id
  ip_protocol       = "tcp"
  from_port         = 5432
  to_port           = 5432
  cidr_ipv4         = aws_vpc.this.cidr_block
  description       = "PostgreSQL from within VPC"
}
