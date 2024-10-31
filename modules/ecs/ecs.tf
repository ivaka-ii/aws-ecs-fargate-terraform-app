resource "aws_ecs_cluster" "ecs_fargate_cluster" {
  name = var.ecs_fargate_cluster_name
}

resource "aws_default_vpc" "default_vpc" {}

resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = var.availability_zones[0]
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = var.availability_zones[1]
}

resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = var.availability_zones[2]
}

resource "aws_ecs_task_definition" "kutt_application_task" {
  family                   = var.kutt_app_task_family
  container_definitions    = <<DEFINITION
    [
      {
          "name": "${var.kutt_app_task_name}",
          "image": "${var.ecr_repo_url}",
          "essential": true,
          "portMappings": [
              {
                  "containerPort": ${var.container_port},
                  "hostPort": ${var.container_port}
              }
          ],
          "memory": 1024,
          "cpu": 512,
          "healthCheck": {
              "command": ["CMD-SHELL", "curl -f http://localhost:${var.container_port}/health || exit 1"],
              "interval": 30,
              "timeout": 5,
              "retries": 3,
              "startPeriod": 120
          },
          "environment": [
            {
                "name": "DB_HOST",
                "value": "${var.db_host}"
            },
            {
                "name": "DB_PORT",
                "value": "5432"
            },
            {
                "name": "REDIS_HOST",
                "value": "${var.redis_host}"
            },
            {
                "name": "REDIS_PORT",
                "value": "6379"
            },
            {
                "name": "NODE_ENV",
                "value": "production"
            }
          ],
          "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/kutt",
                    "awslogs-region": "${var.aws_region}",
                    "awslogs-stream-prefix": "ecs"
                }
            }
      }
    ]
    DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 1024
  cpu                      = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_policy_attachment" "ecs_task_execution_role_policy" {
  name       = var.ecs_task_execution_policy_attachment_name
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_alb" "application_load_balancer" {
  name               = var.application_load_balancer_name
  load_balancer_type = "application"
  subnets = [
    "${aws_default_subnet.default_subnet_a.id}",
    "${aws_default_subnet.default_subnet_b.id}",
    "${aws_default_subnet.default_subnet_c.id}"
  ]
  security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
}

resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = var.target_group_name
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_default_vpc.default_vpc.id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_ecs_service" "kutt_app_service" {
  name            = var.kutt_app_service_name
  cluster         = aws_ecs_cluster.ecs_fargate_cluster.id
  task_definition = aws_ecs_task_definition.kutt_application_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = aws_ecs_task_definition.kutt_application_task.family
    container_port   = var.container_port
  }

  network_configuration {
    subnets = [
      "${aws_default_subnet.default_subnet_a.id}",
      "${aws_default_subnet.default_subnet_b.id}",
      "${aws_default_subnet.default_subnet_c.id}"
    ]
    assign_public_ip = true
    security_groups  = ["${aws_security_group.service_security_group.id}"]
  }
}

resource "aws_security_group" "service_security_group" {
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}