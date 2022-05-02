
#create aws ecr repository 
resource "aws_ecr_repository" "asmt-1-cmba-ecr" {
  name                 = local.ecr_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

#Build docker file 
resource "null_resource" "docker_file" {
  provisioner "local-exec" {
    command = "/bin/bash docker_build.sh"
    environment = {
      image_name     = local.image_name
      image_tag      = var.image_tag
      REPOSITORY_URI = local.REPOSITORY_URI
      REGION         = var.REGION
      aws_account_id = var.aws_account_id
    }
  }
}

#create log group for ecs
resource "aws_cloudwatch_log_group" "logs" {
  name = local.cloudwatch-logs
}

#Create the ecs cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = local.ecs_cluster_name
}

#Create the task definition
resource "aws_ecs_task_definition" "Task" {
  family                   = local.ecs_task_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024

  execution_role_arn = aws_iam_role.ecs_role.arn
  depends_on         = [null_resource.docker_file]
  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = "${aws_ecr_repository.asmt-1-cmba-ecr.repository_url}:latest"
      cpu       = 512
      memory    = 1024
      essential = true
      environment = [
        { "name" : "REDIS_HOST", "value" : "${local.redis_service_name}.${local.namespace}" },
        { "name" : "REDIS_PORT", "value" : "6379" }
      ]
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ],

      logConfiguration = [
        {
          logDriver : "awslogs",
          options : {
            awslogs-group : aws_cloudwatch_log_group.logs.name,
            awslogs-region : var.REGION,
            awslogs-stream-prefix : "ecs"
          }
        }
      ]
    }
  ])
}




#Create the service
resource "aws_ecs_service" "service" {
  name            = local.ecs_service_name
  depends_on      = [aws_ecs_service.redis_service, aws_lb_listener.test_listener, aws_lb_target_group.test-tg]
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.Task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets-list
    security_groups  = [aws_security_group.container_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.test-tg.id
    container_name   = local.container_name
    container_port   = 8000
  }
}

#it is necessary to push to this reposiotry.
resource "aws_codecommit_repository" "asmt-cmba-codecommit" {
  repository_name = local.codecommit-name
  description     = "repository to store the code and files"
}
