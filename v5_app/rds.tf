module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "hello-world-db-postgres"

  engine                       = "postgres"
  engine_version               = "12.2"
  instance_class               = "db.t3.micro"
  allocated_storage            = 30
  storage_encrypted            = true
  performance_insights_enabled = true

  name     = "postgres"
  username = "helloworld"
  password = "verysecretpassword"
  port     = "5432"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [module.db_sg.this_security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 0

  tags = {
    project = "hello-world"
  }

  subnet_ids = data.aws_subnet_ids.all.ids

  family                    = "postgres12"
  major_engine_version      = "12"
  final_snapshot_identifier = "hello-world-db-postgres"
  deletion_protection       = false

  parameters = [
    {
      name  = "random_page_cost"
      value = "1.1"
    }
  ]
}

module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db_sg"
  description = "Security group for db_sg"
  vpc_id      = data.aws_vpc.default.id

  ingress_with_source_security_group_id = [
    {
      description              = "db access"
      rule                     = "postgresql-tcp"
      source_security_group_id = module.ec2_sg.this_security_group_id
    }
  ]
  egress_rules = ["all-all"]
}