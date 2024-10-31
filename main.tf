provider "aws" {
  region = "eu-west-1"
}

module "tfstate" {
  source      = "./modules/tfstate"
  bucket_name = local.bucket_name
  table_name  = local.table_name
}

module "ecrRepo" {
  source        = "./modules/ecr"
  ecr_repo_name = local.ecr_repo_name
}

module "ecs_fargate_cluster" {
  source = "./modules/ecs"

  ecs_fargate_cluster_name = local.ecs_fargate_cluster_name
  availability_zones       = local.availability_zones

  kutt_app_task_family                      = local.kutt_app_task_family
  ecr_repo_url                              = module.ecrRepo.repository_url
  container_port                            = local.container_port
  kutt_app_task_name                        = local.kutt_app_task_name
  ecs_task_execution_role_name              = local.ecs_task_execution_role_name
  ecs_task_execution_policy_attachment_name = local.ecs_task_execution_policy_attachment_name

  application_load_balancer_name = local.application_load_balancer_name
  target_group_name              = local.target_group_name
  kutt_app_service_name          = local.kutt_app_service_name
  db_security_group_id           = local.db_security_group_id
  redis_security_group_id        = local.redis_security_group_id
  db_host                        = local.db_host
  redis_host                     = local.redis_host
}

#create RDS instance and security group for communication with the ECS Fargate cluster
module "dbPostgreSQL" {
  source = "./modules/db_postgresql"

  availability_zones     = local.availability_zones
  db_private_subnet_name = local.db_private_subnet_name
  db_instance_name       = local.db_instance_name
  db_subnet_group_name   = local.db_subnet_group_name

  db_name     = local.db_name
  db_user     = local.db_user
  db_password = local.db_password

  db_security_group         = local.db_security_group
  service_security_group_id = local.service_security_group_id
}

resource "random_password" "db_password" {
  length  = 16    # Password length (adjust as needed)
  special = false # Include special characters
  upper   = true  # Include uppercase letters
  lower   = true  # Include lowercase letters
  numeric = true  # Include numbers
}

#Create Redis
module "redis" {
  source                    = "./modules/redis"
  availability_zones        = local.availability_zones
  redis_cluster_name        = local.redis_cluster_name
  service_security_group_id = local.service_security_group_id
  redis_subnet_group        = local.redis_subnet_group
  redis_private_subnet      = local.redis_private_subnet

  redis_node_type = "cache.t3.micro"

  redis_security_group = local.redis_security_group
}