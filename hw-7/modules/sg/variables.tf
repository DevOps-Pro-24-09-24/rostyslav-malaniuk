variable "vpc_id" {
  description = "The ID of the VPC where the security groups will be created"
  type        = string
}

variable "allowed_ssh_ip" {
  description = "The IP address or CIDR block allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}