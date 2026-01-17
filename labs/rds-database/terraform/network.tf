resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = local.vpc_name }
}

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = local.az_a
  map_public_ip_on_launch = false

  tags = { Name = "${var.project_name}-private-a" }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidr_b
  availability_zone       = local.az_b
  map_public_ip_on_launch = false

  tags = { Name = "${var.project_name}-private-b" }
}

# Route table (ohne Internet/NAT; DB bleibt privat)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.project_name}-rt-private" }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}

# DB Subnet Group: Für RDS nötig (auch Single-AZ)
resource "aws_db_subnet_group" "this" {
  name       = local.subnet_group_name
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = { Name = local.subnet_group_name }
}
