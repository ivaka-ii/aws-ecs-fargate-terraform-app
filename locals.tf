locals {
  #backend
  bucket_name = "tfstate-code-challenge-ivaylo"
  table_name  = "tfstate-code-challenge-ivaylo-lock-table"

  #ecr
  ecr_repo_name = "${var.name_prefix}-container"

  #ecs
  ecs_fargate_cluster_name                  = "${var.name_prefix}-app-cluster"
  availability_zones                        = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  kutt_app_task_family                      = "${var.name_prefix}-app-task"
  container_port                            = 3000
  kutt_app_task_name                        = "${var.name_prefix}-app-task"
  
  ecs_task_execution_role_name              = "${var.name_prefix}-app-task-execution-role"
  ecs_task_execution_policy_attachment_name = "ecs-task-policy-attachment"
  
  service_security_group                    = "${var.name_prefix}-task-sg"
  service_security_group_id                 = module.ecs_fargate_cluster.service_security_group_id
  redis_security_group_id                   = module.redis.redis_security_group_id
  db_security_group_id                      = module.dbPostgreSQL.rds_sg_id
  db_host                                   = module.dbPostgreSQL.db_host
  redis_host                                = module.redis.redis_host

  #alb
  application_load_balancer_name = "${var.name_prefix}-app-alb"
  target_group_name              = "${var.name_prefix}-alb-tg"

  #service
  kutt_app_service_name = "${var.name_prefix}-app-service"

  #database
  db_private_subnet_name = "${var.name_prefix}-db-private-subnet"
  db_instance_name       = "${var.name_prefix}-db-postgres"
  db_name                = "${var.name_prefix}postrgesql"
  db_user                = "${var.name_prefix}admin"
  db_security_group      = "${var.name_prefix}-db-sg"
  db_password            = "test1234"
  db_subnet_group_name   = "${var.name_prefix}-db-subnet-group"

  #redis
  redis_cluster_name   = "${var.name_prefix}-redis-cluster"
  redis_subnet_group   = "${var.name_prefix}-redis"
  redis_security_group = "${var.name_prefix}-redis-sg"
  redis_private_subnet = "${var.name_prefix}-redis-private-subnet"
}