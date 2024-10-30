output "redis_security_group_id" {
  description = "Security group ID for Redis access"
  value       = aws_security_group.redis_security_group.id
}

output "redis_host" {
  description = "redis host"
  value       = aws_elasticache_cluster.redis_cluster.cluster_id
}