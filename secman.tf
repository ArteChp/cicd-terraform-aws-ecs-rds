data "aws_secretsmanager_secret" "rds_user" {
  name = "${var.environment}/user/rds"
}

data "aws_secretsmanager_secret_version" "rds_user" {
  secret_id = data.aws_secretsmanager_secret.rds_user.id
}
