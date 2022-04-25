source_repo_name   = "simple-aspnet-app"
source_repo_branch = "master"
image_repo_name    = "simple-aspnet-app"
region             = "us-east-1"
role_arn           = "arn:aws:iam::373011342827:role/terraform-bitbucket-pipelines"
map_tags_auto = {
  auto-delete = "never"
  auto-stop   = "no"
}
