
module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name     = local.dynamodb_table
  hash_key = "LockID"

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]
}

import {
  to = module.dynamodb_table.aws_dynamodb_table.this[0]
  id = local.dynamodb_table
}

