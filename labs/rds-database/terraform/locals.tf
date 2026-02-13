data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

locals {
  az_a = data.aws_availability_zones.available.names[0]
  az_b = data.aws_availability_zones.available.names[1]

  name_suffix       = random_string.suffix.result
  vpc_name          = "${var.project_name}-vpc-${local.name_suffix}"
  db_identifier     = "${var.project_name}-${local.name_suffix}"
  subnet_group_name = "${var.project_name}-subnets-${local.name_suffix}"
}
