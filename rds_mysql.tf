provider "aws" {
  region = "us-west-2"
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "latest"
  instance_class       = "db.t3.micro"
  name                 = "mydatabase"
  username             = "admin"
  password             = "password1234"
  parameter_group_name = "default.mysql8.0"

  # Backup and Maintenance settings (optional)
  backup_retention_period = 7
  backup_window           = "07:00-09:00"
  maintenance_window      = "Mon:00:00-Mon:03:00"

  # Multi-AZ configuration for high availability (optional)
  multi_az = false

  skip_final_snapshot = true
}

output "rds_endpoint" {
  value = aws_db_instance.default.endpoint
}
