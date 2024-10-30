output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}

output "ecs_service_security_group_id" {
  description = "Security group ID for ECS service"
  value       = module.ecs_fargate_cluster.service_security_group_id
}