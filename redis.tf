
#Create the task definition
resource "aws_ecs_task_definition" "redis_task" {
  family                   = local.ecs_task_name_redis
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_role.arn
  depends_on               = [null_resource.docker_file]
  container_definitions = jsonencode([
    {
      name      = "${local.container_name}-redis"
      image     = "redis:alpine"
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 6379
          hostPort      = 6379
        }
      ]
    }
  ])
}

#Create the service
resource "aws_ecs_service" "redis_service" {
  name    = local.ecs_service_name_redis
  cluster = aws_ecs_cluster.ecs_cluster.id
  service_registries {
    registry_arn   = aws_service_discovery_service.redis_service_discovery.arn
    container_name = "${local.container_name}-redis"
  }
  task_definition = aws_ecs_task_definition.redis_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.subnets-list
    security_groups  = [aws_security_group.redis_sg.id]
    assign_public_ip = true
  }
}

resource "aws_service_discovery_private_dns_namespace" "local_namespace" {
  name        = local.namespace
  description = "chizzy namespace"
  vpc         = var.vpc-id
}

resource "aws_service_discovery_service" "redis_service_discovery" {
  name = local.redis_service_name

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.local_namespace.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "WEIGHTED"
  }

}


