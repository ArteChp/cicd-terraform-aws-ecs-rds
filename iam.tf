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
      "${module.backend_s3_bucket.s3_bucket_arn}",
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
      "${module.backend_s3_bucket.s3_bucket_arn}/*",
    ]
  }
}


