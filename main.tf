provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}


locals {

  vpc_cidr        = var.vpc_cidr_block
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  name            = "${var.name}-${var.environment}"
  env             = var.environment
  region          = var.region
  container_name  = var.name
  container_port  = 8080
  container_image = "204848234318.dkr.ecr.us-west-2.amazonaws.com/csgtest-cicd-terraform-aws-ecs-rds:latest"
  bucket          = "terraform-backend-${local.name}"
  db_name         = jsondecode(data.aws_secretsmanager_secret_version.rds_user.secret_string)["dbname"]
  db_user         = jsondecode(data.aws_secretsmanager_secret_version.rds_user.secret_string)["username"]
  db_port         = jsondecode(data.aws_secretsmanager_secret_version.rds_user.secret_string)["port"]
  tags = {
    Name        = var.name
    Environment = var.environment
  }

}
