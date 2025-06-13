resource "aws_ecr_repository" "retail" {
  name = "retail"
}

//need to deploy images here before even deploy all other stuffs and mix this logic with cli
