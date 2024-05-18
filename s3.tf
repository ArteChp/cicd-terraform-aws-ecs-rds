
resource "aws_s3_bucket" "terraform_backend" {
  bucket = "terraform-backend-test"

  tags = {
    Name        = "Terraform backend"
  }
}

resource "aws_s3_bucket_versioning" "terraform_backend_versioning" {
  bucket = aws_s3_bucket.terraform_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "terraform_backend" {
  bucket = aws_s3_bucket.terraform_backend.id
  policy = data.aws_iam_policy_document.terraform_backend.json
}

data "aws_iam_policy_document" "terraform_backend" {
  statement {

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_caller_identity.current.arn}"]
    }

    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.terraform_backend.arn}",
    ]
  }
  statement {

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_caller_identity.current.arn}"]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.terraform_backend.arn}/production",
      "${aws_s3_bucket.terraform_backend.arn}/development",
    ]
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_backend" {
  bucket = aws_s3_bucket.terraform_backend.id

  rule {
    bucket_key_enabled = false

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
