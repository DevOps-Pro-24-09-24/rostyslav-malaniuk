# AWS region
variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

# AMI ID for EC2 instances
variable "ami_id" {
  description = "AMI ID for instances"
  type        = string
  #default = "ami-0eddb4a4e7d846d6f" # amazon
  default = "ami-0117e0866dc5caa32" # Ubuntu Minimal, 24.04, amd64 noble image
  #default = "ami-086b1f73a9323389e" # hw-5
}

# Instance type for EC2 instances
variable "instance_type" {
  description = "Type of instance to use"
  type        = string
  default     = "t2.micro"
}

# CIDR block for the VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/24"
}

# CIDR block for the public subnet
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "192.168.0.0/25"
}

# CIDR block for the private subnet
variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "192.168.0.128/25"
}

# IP address allowed for SSH access
variable "allowed_ssh_ip" {
  description = "IP address allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}

# Name of the SSH key
variable "key_name" {
  description = "Name of the SSH key"
  type        = string
  default     = "web-key"
}

## Password for the RDS instance
#variable "db_password" {
#  description = "Password for the RDS instance"
#  type        = string
#  sensitive   = true
#}

variable "db_name" {
  type      = string
  sensitive = true
}

variable "db_user" {
  type      = string
  sensitive = true
}