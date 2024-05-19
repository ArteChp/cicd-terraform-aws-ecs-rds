

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

# data "aws_iam_policy_document" "ecs_role" {
#   statement {
#
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#
#     effect = "Allow"
#
#     actions = [
#       "sts:AssumeRole",
#     ]
#   }
# }
#
# data "aws_iam_role" "ecs_role" {
#   name = "ecs-role"
#   assume_role_policy = data.aws_iam_policy_document.ecs_role.json
# }




