output "rds_sg_id" {
  value = aws_security_group.db.id
}

output "db_host" {
  value = aws_db_instance.postgres.db_name
}