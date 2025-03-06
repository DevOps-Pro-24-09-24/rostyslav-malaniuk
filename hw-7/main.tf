module "sg" {
  source         = "./modules/sg"
  vpc_id         = module.vpc.vpc_id
  allowed_ssh_ip = var.allowed_ssh_ip
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "my-db-password"
}

locals {
  db_password = data.aws_secretsmanager_secret_version.db_password.secret_string
}

module "rds" {
  source = "./modules/rds"

  db_name = var.db_name
  db_user = var.db_user
  # db_password            = var.db_password
  db_password            = local.db_password
  private_subnet_ids     = module.vpc.private_subnet_ids
  vpc_security_group_ids = [module.sg.sg_RDS_id]
}

module "ec2" {
  source = "./modules/ec2"

  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnet_id
  vpc_security_group_ids = [module.sg.sg_FRONT_id]
  key_name               = var.key_name
  rds_endpoint           = module.rds.db_endpoint
  db_user                = var.db_user
  # db_password            = var.db_password
  db_password = local.db_password
  db_name     = var.db_name
}