#
# data "aws_secretsmanager_secret" "mysql_root" {
#   name = "dev/root/mysql"
# }
#
# data "aws_secretsmanager_secret_version" "mysql_root" {
#   secret_id = data.aws_secretsmanager_secret.mysql_root.id
# }
#
# data "aws_secretsmanager_secret" "mysql_user1" {
#   name = "dev/user1/mysql"
# }
#
# data "aws_secretsmanager_secret_version" "mysql_user1" {
#   secret_id = data.aws_secretsmanager_secret.mysql_user1.id
# }
#
# data "aws_secretsmanager_secret" "mysql_user2" {
#   name = "dev/user2/mysql"
# }
#
# data "aws_secretsmanager_secret_version" "mysql_user2" {
#   secret_id = data.aws_secretsmanager_secret.mysql_user2.id
# }
#
# data "aws_secretsmanager_secret" "aws_api_credentials" {
#   name = "prod/AWS/CAcreds"
# }
#
# data "aws_secretsmanager_secret_version" "aws_api_credentials" {
#   secret_id = data.aws_secretsmanager_secret.aws_api_credentials.id
# }

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "region" {
  description = "AWS region name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr_blocks" {
  description = "A list of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "A list of CIDR blocks for private subnets"
  type        = list(string)
}

variable "name" {
  description = "The name of the project"
  type        = string
}

variable "container_name" {
  description = "The name of a container"
  type        = string
}

variable "container_port" {
  description = "The port of a container"
  type        = string
}
