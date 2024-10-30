resource "aws_default_vpc" "default_vpc" {}

resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = var.availability_zones[0]
}

resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = var.availability_zones[2]
}

resource "aws_db_subnet_group" "db_private_subnet" {
  name       = var.db_private_subnet_name
  subnet_ids = [aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_c.id]
}

resource "aws_db_instance" "postgres" {
  identifier        = var.db_instance_name
  engine            = "postgres"
  engine_version    = "14"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = var.db_name
  username = var.db_user
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.db_private_subnet.name

  backup_retention_period = 7
  multi_az                = false
  skip_final_snapshot     = true
}

resource "aws_security_group" "db" {
  name        = var.db_security_group
  description = "Database Security Group"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${var.service_security_group_id}"]
  }
}