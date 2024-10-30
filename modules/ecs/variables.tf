variable "ecs_fargate_cluster_name" {
  description = "ECS Fargate Cluster Name"
  type        = string
}

variable "availability_zones" {
  description = "eu-west-1 AZs"
  type        = list(string)
}

variable "kutt_app_task_family" {
  description = "ECS Task Family"
  type        = string
}

variable "ecr_repo_url" {
  description = "ECR Repo URL"
  type        = string
}

variable "container_port" {
  description = "Container Port"
  type        = number
}

variable "kutt_app_task_name" {
  description = "ECS Task Name"
  type        = string
}

variable "ecs_task_execution_role_name" {
  description = "ECS Task Execution Role Name"
  type        = string
}

variable "application_load_balancer_name" {
  description = "ALB Name"
  type        = string
}

variable "target_group_name" {
  description = "ALB Target Group Name"
  type        = string
}

variable "kutt_app_service_name" {
  description = "ECS Service Name"
  type        = string
}

variable "ecs_task_execution_policy_attachment_name" {
  description = "ECS Task Execution Policy Attachment Name"
  type        = string
}

variable "db_security_group_id" {
  description = "ID of the database security group"
  type        = string
}

variable "redis_security_group_id" {
  description = "ID of the redis security group"
  type        = string
}

variable "db_host" {
  description = "the host of Postgresql"
  type        = string
}

variable "redis_host" {
  description = "the host of redis"
  type        = string
}