resource "aws_codeartifact_domain" "pidedirecto_domain" {
  domain = var.domain_name
}

resource "aws_codeartifact_repository" "pidedirecto_repo" {
  repository = var.repository_name
  domain     = aws_codeartifact_domain.pidedirecto_domain.domain

  lifecycle {
    ignore_changes = [ external_connections ]
  }
}

resource "null_resource" "associate_npm_connection" {
  provisioner "local-exec" {
    command = "aws codeartifact associate-external-connection --domain ${aws_codeartifact_domain.pidedirecto_domain.domain} --repository ${aws_codeartifact_repository.pidedirecto_repo.repository} --external-connection public:npmjs --profile ${var.aws_profile}"
  }

  triggers = {
    domain_name         = var.domain_name
    repository_name     = var.repository_name
    external_connection = "public:npmjs"
  }

  depends_on = [aws_codeartifact_repository.pidedirecto_repo]
}
