resource "aws_codeartifact_domain" "pidedirecto_domain" {
  domain = "pidedirecto"
}

resource "aws_codeartifact_repository" "pidedirecto_repo" {
  repository = "npm"
  domain     = aws_codeartifact_domain.pidedirecto_domain.domain
}

resource "null_resource" "associate_npm_connection" {
  provisioner "local-exec" {
    command = "aws codeartifact associate-external-connection --domain ${aws_codeartifact_domain.pidedirecto_domain.domain} --repository ${aws_codeartifact_repository.pidedirecto_repo.repository} --external-connection public:npmjs --profile ${var.aws_profile}"
  }

  depends_on = [aws_codeartifact_repository.pidedirecto_repo]
}
