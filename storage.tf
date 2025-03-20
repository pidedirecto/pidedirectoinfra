resource "aws_s3_bucket" "my_bucket" {
  bucket        = "npm.test.pkg.pidedirecto.mx"
  force_destroy = true
}