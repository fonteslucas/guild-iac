resource "aws_codecommit_repository" "source_repo" {
  repository_name = var.source_repo_name
  description     = "Source App Repo"
}

resource "aws_iam_role" "trigger_role" {
  assume_role_policy = file("policys/allow_rule_invoke_pipeline.json")
  path               = "/"
}

resource "aws_iam_policy" "trigger_policy" {
  description = "Policy Allow Rule invoke pipeline"
  policy      = file("policys/allow_rule_invoke_pipeline.json")
}

resource "aws_iam_role_policy_attachment" "trigger-attach" {
  role       = aws_iam_role.trigger_role.name
  policy_arn = aws_iam_policy.trigger_policy.arn
}

resource "aws_cloudwatch_event_rule" "trigger_rule" {
  description   = "Trigger the pipeline on change to repo/branch"
  event_pattern = file("policys/triger_pipeline_repo-branch.json")
  role_arn      = aws_iam_role.trigger_role.arn
  is_enabled    = true
}

resource "aws_cloudwatch_event_target" "target_pipeline" {
  rule      = aws_cloudwatch_event_rule.trigger_rule.name
  arn       = aws_codepipeline.pipeline.arn
  role_arn  = aws_iam_role.trigger_role.arn
  target_id = "${var.source_repo_name}-${var.source_repo_branch}-pipeline"
}

resource "aws_ecr_repository" "image_repo" {
  name                 = var.image_repo_name
  image_tag_mutability = "MUTABLE"
}

resource "aws_iam_role" "codebuild_role" {
  assume_role_policy = file("policys/codebuild_role.json")
  path               = "/"
}

resource "aws_iam_policy" "codebuild_policy" {
  description = "Policy to allow codebuild to execute build spec"
  policy      = file("policys/codebuild_policy.json")
}

resource "aws_iam_role_policy_attachment" "codebuild-attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

resource "aws_iam_role" "codebuild_terraform_role" {
  assume_role_policy = file("policys/codebuild_terraform_role.json")
  path               = "/"
}

resource "aws_iam_policy" "codebuild_terraform_policy" {
  description = "Policy to allow codebuild to execute build spec"
  policy      = file("policys/codebuild_terraform_policy.json")
}

resource "aws_iam_role_policy_attachment" "codebuild-terraform-attach" {
  role       = aws_iam_role.codebuild_terraform_role.name
  policy_arn = aws_iam_policy.codebuild_terraform_policy.arn
}

resource "aws_iam_role" "codepipeline_role" {
  assume_role_policy = file("policys/codepipeline_role.json")
  path               = "/"
}

resource "aws_iam_policy" "codepipeline_policy" {
  description = "Policy to allow codepipeline to execute"
  policy      = file("policys/codepipeline_policy.json")
}

resource "aws_iam_role_policy_attachment" "codepipeline-attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

# Alteração no metodo de input das tags
resource "aws_s3_bucket" "artifact_bucket" {
  tags = var.map_tags_auto
}

# Alteração no metodo de input das tags
resource "aws_s3_bucket" "tfstate_bucket" {
  tags = var.map_tags_auto
}

resource "aws_codebuild_project" "codebuild" {
  depends_on = [
    aws_codecommit_repository.source_repo,
    aws_ecr_repository.image_repo
  ]
  name         = "codebuild-${var.source_repo_name}-${var.source_repo_branch}"
  service_role = aws_iam_role.codebuild_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = data.aws_region.current.name
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = var.image_repo_name
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = file("buildspecs/first.yml")
  }
}

resource "aws_codebuild_project" "codebuild_tfsec" {
  depends_on = [
    aws_codecommit_repository.source_repo
  ]
  name         = "codebuild_tfsec-${var.source_repo_name}-${var.source_repo_branch}"
  service_role = aws_iam_role.codebuild_terraform_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "tfsec/tfsec:latest"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = data.aws_region.current.name
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = file("buildspecs/second.yml")
  }
}

resource "aws_codebuild_project" "codebuild_tflint" {
  depends_on = [
    aws_codecommit_repository.source_repo
  ]
  name         = "codebuild_tflint-${var.source_repo_name}-${var.source_repo_branch}"
  service_role = aws_iam_role.codebuild_terraform_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
    image_pull_credentials_type = "CODEBUILD"
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = file("buildspecs/thirdy.yml")
  }
}


resource "aws_codebuild_project" "codebuild_terraform_plan" {
  depends_on = [
    aws_codecommit_repository.source_repo
  ]
  name         = "codebuild_terraform_plan-${var.source_repo_name}-${var.source_repo_branch}"
  service_role = aws_iam_role.codebuild_terraform_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = data.aws_region.current.name
    }
    environment_variable {
      name  = "TF_VERSION"
      value = "1.0.5"
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = file("buildspecs/fourth.yml")
  }
}

resource "aws_codebuild_project" "codebuild_terraform" {
  depends_on = [
    aws_codecommit_repository.source_repo
  ]
  name         = "codebuild_terraform-${var.source_repo_name}-${var.source_repo_branch}"
  service_role = aws_iam_role.codebuild_terraform_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = data.aws_region.current.name
    }
    environment_variable {
      name  = "TF_VERSION"
      value = "1.0.5"
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = file("buildspecs/fifth.yml")
  }
}

resource "aws_codepipeline" "pipeline" {
  depends_on = [
    aws_codebuild_project.codebuild,
    aws_codebuild_project.codebuild_terraform,
    aws_codebuild_project.codebuild_terraform_plan,
    aws_codebuild_project.codebuild_tflint,
    aws_codebuild_project.codebuild_tfsec
  ]
  name     = "${var.source_repo_name}-${var.source_repo_branch}-Pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn
  artifact_store {
    location = aws_s3_bucket.artifact_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeCommit"
      output_artifacts = ["SourceOutput"]
      run_order        = 1
      configuration = {
        RepositoryName       = var.source_repo_name
        BranchName           = var.source_repo_branch
        PollForSourceChanges = "false"
      }
    }
  }
  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]
      run_order        = 1
      configuration = {
        ProjectName = aws_codebuild_project.codebuild.id
      }
    }
  }
  stage {
    name = "tf-sec-lint"
    action {
      name            = "tf-sec"
      category        = "Build"
      owner           = "AWS"
      version         = "1"
      provider        = "CodeBuild"
      input_artifacts = ["SourceOutput"]
      run_order       = 1
      namespace       = "TFSEC"
      configuration = {
        ProjectName = aws_codebuild_project.codebuild_tfsec.id
      }
    }
    action {
      name            = "tf-lint"
      category        = "Build"
      owner           = "AWS"
      version         = "1"
      provider        = "CodeBuild"
      input_artifacts = ["SourceOutput"]
      run_order       = 1
      configuration = {
        ProjectName = aws_codebuild_project.codebuild_tflint.id
      }
    }
  }
  stage {
    name = "TerraformActions"
    action {
      name      = "approval-tfsec"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
      run_order = 1
      configuration = {
        CustomData         = "tfsec errors found: #{TFSEC.checks_errors}, tfsec high found: #{TFSEC.check_high}, tfsec warning found: #{TFSEC.check_warning}, tfsec low found: #{TFSEC.check_low}"
        ExternalEntityLink = "https://#{TFSEC.Region}.console.aws.amazon.com/codesuite/codebuild/${data.aws_caller_identity.current.account_id}/projects/#{TFSEC.BuildID}/build/#{TFSEC.BuildID}%3A#{TFSEC.BuildTag}/reports?region=#{TFSEC.Region}"
      }
    }
    action {
      name            = "TerraformPlan"
      category        = "Build"
      owner           = "AWS"
      version         = "1"
      provider        = "CodeBuild"
      input_artifacts = ["SourceOutput"]
      run_order       = 2
      configuration = {
        ProjectName = aws_codebuild_project.codebuild_terraform_plan.id
      }
    }
    action {
      name      = "approval-terraform-plan"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
      run_order = 3
    }

    # teste
    action {
      name            = "TerraformApply"
      category        = "Build"
      owner           = "AWS"
      version         = "1"
      provider        = "CodeBuild"
      input_artifacts = ["SourceOutput"]
      run_order       = 4
      configuration = {
        ProjectName = aws_codebuild_project.codebuild_terraform.id
      }
    }
  }
}