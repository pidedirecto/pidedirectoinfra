resource "aws_s3_bucket" "temp_bucket" {
  bucket = var.temp_bucket_name

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "temp_bucket_config" {
  bucket = aws_s3_bucket.temp_bucket.id

  rule {
    id     = "expire_after_7days"
    status = "Enabled"
    expiration {
      days = 7
    }
  }
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = var.public_bucket_name
}

resource "aws_s3_bucket_public_access_block" "public_bucket_access_block" {
  bucket                  = aws_s3_bucket.public_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "public_bucket_policy" {
  bucket = aws_s3_bucket.public_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.oai.id}"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.public_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket" "private_bucket" {
  bucket = var.private_bucket_name
}

resource "aws_s3_bucket_public_access_block" "private_bucket_access_block" {
  bucket                  = aws_s3_bucket.private_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
