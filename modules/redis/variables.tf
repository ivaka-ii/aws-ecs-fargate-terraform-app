variable "availability_zones" {
  description = "eu-west-1 AZs"
  type        = list(string)
}

variable "redis_cluster_name" {
  description = "Name of Redis cluster"
  type        = string
}

variable "redis_private_subnet" {
  description = "Name of Redis subnet"
  type        = string
}

variable "redis_subnet_group" {
  description = "Name of Redis subnet group"
  type        = string
}

variable "redis_node_type" {
  description = "Instance type for Redis cluster"
  type        = string
}

variable "redis_security_group" {
  description = "Name of the redis security group"
  type        = string
}

variable "service_security_group_id" {
  description = "Name of the security group to associate with the redis cache"
  type        = string
}