resource "aws_ecr_repository" "kutt_repository" {
  name = var.ecr_repo_name
}