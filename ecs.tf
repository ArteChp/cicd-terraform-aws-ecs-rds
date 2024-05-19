module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "ecs-cluster"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  services = {
    ecsdemo-frontend = {
      cpu    = 1024
      memory = 4096

      # Container definition(s)
      container_definitions = {

        fluent-bit = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "906394416424.dkr.ecr.us-west-2.amazonaws.com/aws-for-fluent-bit:stable"
          firelens_configuration = {
            type = "fluentbit"
          }
          memory_reservation = 50
        }

        ecs-sample = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "public.ecr.aws/aws-containers/ecsdemo-frontend:776fd50"
          port_mappings = [
            {
              name          = "ecs-sample"
              containerPort = var.container_port 
              protocol      = "tcp"
            }
          ]

          # Example image used requires access to write to root filesystem
          readonly_root_filesystem = false

          dependencies = [{
            containerName = "fluent-bit"
            condition     = "START"
          }]

          enable_cloudwatch_logging = false
          log_configuration = {
            logDriver = "awsfirelens"
            options = {
              Name                    = "firehose"
              region                  = var.region 
              delivery_stream         = "my-stream"
              log-driver-buffer-limit = "2097152"
            }
          }
          memory_reservation = 100
        }
      }

      service_connect_configuration = {
        namespace = "example"
        service = {
          client_alias = {
            port     = var.container_port 
            dns_name = var.container_name 
          }
          port_name      = "ecs-sample"
          discovery_name = var.container_name 
        }
      }

      load_balancer = {
        service = {
          target_group_arn = module.alb.target_groups["ex_ecs"].arn 
          container_name   = var.container_name 
          container_port   = var.container_port 
        }
      }

      subnet_ids = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id] 
      security_group_rules = {
        alb_ingress_3000 = {
          type                     = "ingress"
          from_port                = var.container_name
          to_port                  = var.container_port
          protocol                 = "tcp"
          description              = "Service port"
          source_security_group_id = module.alb.security_group_id 
        }
        egress_all = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }

  tags = {
    Environment = var.environment 
    Project     = "Test task"
  }
}
