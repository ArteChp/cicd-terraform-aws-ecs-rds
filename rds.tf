module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = local.name

  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t4g.micro"
  allocated_storage     = 5
  max_allocated_storage = 20

  db_name  = local.db_name
  username = local.db_user
  port     = local.db_port

  manage_master_user_password = true
  vpc_security_group_ids      = [module.security_group.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = local.name
  create_monitoring_role = true

  tags = local.tags

  # DB subnet group
  multi_az             = true
  db_subnet_group_name = module.vpc.database_subnet_group

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

}
