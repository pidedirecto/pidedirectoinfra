resource "aws_codeartifact_domain" "pidedirecto_domain" {
  domain = "pidedirecto"
}

resource "aws_codeartifact_repository" "pidedirecto_repo" {
  repository = "cli"
  domain     = aws_codeartifact_domain.pidedirecto_domain.domain
}

output "codeartifact_repository_url" {
  value = aws_codeartifact_repository.pidedirecto_repo.repository
}