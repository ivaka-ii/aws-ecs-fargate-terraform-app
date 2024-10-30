resource "aws_default_vpc" "default_vpc" {}

resource "aws_default_subnet" "default_subnet_e" {
  availability_zone = var.availability_zones[1]
}

resource "aws_elasticache_subnet_group" "redis_private_subnet" {
  name       = var.redis_private_subnet
  subnet_ids = [aws_default_subnet.default_subnet_e.id]
}

resource "aws_elasticache_parameter_group" "redis_parameter_group" {
  name        = "my-redis-parameter-group"  # Unique name for the parameter group
  family      = "redis6.x"                   # Specify the family for Redis 7.x
  description = "Redis parameter group for Redis 6.x"
}

resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id           = var.redis_cluster_name
  engine               = "redis"
  engine_version       = "6.x"
  node_type            = var.redis_node_type
  num_cache_nodes      = 1 # Single node; for production, use Replication Groups
  parameter_group_name = aws_elasticache_parameter_group.redis_parameter_group.name
  subnet_group_name    = aws_elasticache_subnet_group.redis_private_subnet.name
  security_group_ids   = [aws_security_group.redis_security_group.id]
}

resource "aws_security_group" "redis_security_group" {
  name        = var.redis_security_group
  description = "Security group for Redis cache"
  vpc_id      = aws_default_vpc.default_vpc.id

  # Allow inbound traffic on Redis port 6379 from the task security group
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = ["${var.service_security_group_id}"]
  }
}
