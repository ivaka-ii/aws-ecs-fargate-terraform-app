output "service_security_group_id" {
  description = "Security group ID for service"
  value       = aws_security_group.service_security_group.id
}