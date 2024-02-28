resource "aws_s3_bucket" "example_bucket" {
  bucket = "sbai-assistent-bucket"

  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "Examplebucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_public_access_block" "example_bucket_public_access" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example_bucket_encryption" {
  bucket = aws_s3_bucket.example_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_iam_user" "testing_sb_user" {
  name = "testing-sb"
}

resource "aws_iam_access_key" "testing_sb_access_key" {
  user = aws_iam_user.testing_sb_user.name
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

locals {
  bucket_endpoint_url = "https://${aws_s3_bucket.example_bucket.bucket}.s3.${data.aws_region.current.name}.amazonaws.com"
  bucket_region_name  = data.aws_region.current.name
  bucket_name  = aws_s3_bucket.example_bucket.bucket
  bucket_endpoint_arn   = aws_s3_bucket.example_bucket.arn
  bucket_account_no   = data.aws_caller_identity.current.account_id 

}

resource "local_file" "global_cloud_values" {
  filename = "../helmcharts/global-cloud-values.yaml"
  content  = <<-EOT
global:
  bucket_endpoint_url: "${local.bucket_endpoint_url}"
  bucket_region_name: "${local.bucket_region_name}"
  bucket_name: "${local.bucket_name}"
  bucket_endpoint_arn: "${local.bucket_endpoint_arn}"
  bucket_account_no: "${local.bucket_account_no}"
  bucket_secret_key: "${aws_iam_access_key.testing_sb_access_key.secret}"
  bucket_access_key: "${aws_iam_access_key.testing_sb_access_key.id}"  
EOT
}


