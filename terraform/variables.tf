variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "192.168.0.0/24"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  default     = "192.168.0.0/25"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  default     = "192.168.0.128/25"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair name"
}
