module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = local.dynamodb_table 
  hash_key = "LockID"

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]

  tags = local.tags
}
