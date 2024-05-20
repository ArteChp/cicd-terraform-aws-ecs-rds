
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

variable "name" {
  description = "The name of the project"
  type        = string
}
