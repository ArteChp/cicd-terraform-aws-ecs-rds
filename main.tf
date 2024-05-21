provider "aws" {
  region = var.region 
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}


locals {

  vpc_cidr = var.vpc_cidr_block
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  container_name = var.name 
  container_port = 8080 
  container_image = "204848234318.dkr.ecr.us-west-2.amazonaws.com/csgtest-cicd-terraform-aws-ecs-rds:latest"
  tags = {
    Name = var.name
    Environment = var.environment
  }

}
