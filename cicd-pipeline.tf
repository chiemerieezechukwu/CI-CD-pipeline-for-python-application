
#s3 bucket to store artifacts
resource "aws_s3_bucket" "asmt-cmba-codepipeline-artifacts" {
  bucket = local.bucket_name
  acl    = "private"
}

#codebuild block
resource "aws_codebuild_project" "ContainerAppBuild" {
  badge_enabled  = false
  build_timeout  = 60
  name           = local.build-project-name
  queued_timeout = 480
  service_role   = aws_iam_role.CodeBuildRole.arn
  tags = {
    Environment = "QA"
  }

  artifacts {
    encryption_disabled = false
    packaging           = "NONE"
    type                = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {

    type      = "CODEPIPELINE"
    buildspec = "buildspec.yaml"
  }
}

#codepipeline block
resource "aws_codepipeline" "codepipeline" {
  name     = local.pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.asmt-cmba-codepipeline-artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = local.codecommit-name
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.ContainerAppBuild.name
        "EnvironmentVariables" = jsonencode(
          [
            {
              name  = "TF_VERSION"
              type  = "PLAINTEXT"
              value = var.TF_VERSION
            },

            {
              name  = "aws_account_id"
              type  = "PLAINTEXT"
              value = var.aws_account_id
            },

            {
              name  = "REPOSITORY_URI"
              type  = "PLAINTEXT"
              value = local.REPOSITORY_URI
            },

            {
              name  = "image_name"
              type  = "PLAINTEXT"
              value = local.image_name
            },

            {
              name  = "image_tag"
              type  = "PLAINTEXT"
              value = var.image_tag
            },

            {
              name  = "container_name"
              type  = "PLAINTEXT"
              value = local.container_name
            },
          ]
        )
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        "ClusterName" = aws_ecs_cluster.ecs_cluster.name
        "ServiceName" = aws_ecs_service.service.name
      }
    }
  }
}

