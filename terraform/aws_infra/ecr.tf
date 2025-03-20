#########
# ECR configuration

resource "aws_ecr_repository" "ecr" {
  # checkov:skip=BC_AWS_GENERAL_24: Scan using Prisma Cloud
  name                 = local.ecr_name
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true # Useful to compare findings
  }
  encryption_configuration {
    encryption_type = "KMS"
  }
  force_delete = true
  tags = {
    yor_trace = "3bb57c5b-2725-4310-811a-503e732a0575"
  }
}

resource "aws_ecr_lifecycle_policy" "ecr" {
  repository = aws_ecr_repository.ecr.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 2 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 2
      }
    }]
  })
}