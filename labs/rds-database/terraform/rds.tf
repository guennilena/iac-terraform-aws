resource "aws_db_instance" "postgres" {
  identifier = local.db_identifier

  engine         = "postgres"
  engine_version = "16" # falls Region das nicht hat, nehmen wir 15; kann man bei Bedarf anpassen

  instance_class = "db.t4g.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db.id]

  publicly_accessible = false
  multi_az            = false

  # Erzwingt die AZ für Single-AZ
  availability_zone = local.az_a

  backup_retention_period = 1

  deletion_protection = false
  skip_final_snapshot = true

  # Für Labs hilfreich (sonst kann Apply an Minor-Versionen hängen)
  auto_minor_version_upgrade = true
}
