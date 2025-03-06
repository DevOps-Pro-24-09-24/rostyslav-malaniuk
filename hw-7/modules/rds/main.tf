# Create DB subnet group
resource "aws_db_subnet_group" "default" {
  name       = "main-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "db-subnet-group"
  }
}

# Create RDS instance
resource "aws_db_instance" "default" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_user
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.default.name
  skip_final_snapshot    = true
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = {
    Name = "rds-instance"
  }
}