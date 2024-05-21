output "aws_alb_dns" {
  value = module.alb.dns_name
}

output "rds_instance_address" {
  value = module.db.db_instance_address
}
