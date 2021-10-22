#ECS role and policy
data "aws_iam_policy_document" "ecs_tasks_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_role" {
  name               = local.ecs_role
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_role.json
}

resource "aws_iam_role_policy_attachment" "AmazonECS_FullAccess" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
}


#code build roles
data "aws_iam_policy_document" "CodeBuildProjectRole" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "codebuildpolicy" {
  name = local.codebuildpoilicy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["cloudwatch:*", "s3:*", "codebuild:*", "ecr:*", "iam:*", "logs:*"]
        Resource = "*"
      },
    ]
  })
}



resource "aws_iam_role" "CodeBuildRole" {
  name               = local.CodeBuildRole
  assume_role_policy = data.aws_iam_policy_document.CodeBuildProjectRole.json
}

resource "aws_iam_role_policy_attachment" "codebuild_policy-attachment" {
  role       = aws_iam_role.CodeBuildRole.name
  policy_arn = aws_iam_policy.codebuildpolicy.arn
}

#code pipeline role
data "aws_iam_policy_document" "codepipeline_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = local.codepipeline_role
  assume_role_policy = data.aws_iam_policy_document.codepipeline_role.json

}

resource "aws_iam_policy" "codepipelinepolicy" {
  name = local.codepipelinepoilicy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ecs:*", "s3:*", "codecommit:*", "codepipeline:*", "codebuild:*", "codedeploy:*", "iam:*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "CodePipeline_Policy_attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipelinepolicy.arn
}
