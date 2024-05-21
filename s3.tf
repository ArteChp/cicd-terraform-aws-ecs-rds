module "backend_s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = local.bucket
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  attach_policy = true
  policy        = data.aws_iam_policy_document.terraform_backend.json

  versioning = {
    enabled = true
  }
  tags = local.tags
}

