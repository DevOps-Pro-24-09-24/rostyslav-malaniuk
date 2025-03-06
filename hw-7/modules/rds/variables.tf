variable "db_name" {
  description = "The name of the database to create"
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "The username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password for the database user"
  type        = string
  sensitive   = true
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the RDS instance"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the DB subnet group"
  type        = list(string)
}