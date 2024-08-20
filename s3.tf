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
}

import {
  to = module.backend_s3_bucket.aws_s3_bucket.this[0]
  id = local.bucket
}

import {
  to = module.backend_s3_bucket.aws_s3_bucket_acl.this[0]
  id = "${local.bucket},private"
}

import {
  to = module.backend_s3_bucket.aws_s3_bucket_ownership_controls.this[0]
  id = local.bucket
}

import {
  to = module.backend_s3_bucket.aws_s3_bucket_public_access_block.this[0]
  id = local.bucket
}

import {
  to = module.backend_s3_bucket.aws_s3_bucket_versioning.this[0]
  id = local.bucket
}
