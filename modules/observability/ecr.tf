resource "aws_ecr_repository" "grafana_alloy" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = var.repository_name
    Environment = var.env
  }
}

resource "aws_ecr_lifecycle_policy" "grafana_alloy_policy" {
  repository = aws_ecr_repository.grafana_alloy.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 2 days"
        selection = {
          tagStatus     = "untagged"
          countType     = "sinceImagePushed"
          countUnit     = "days"
          countNumber   = 2
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
