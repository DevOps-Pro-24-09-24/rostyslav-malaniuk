variable "region" {
  description = "The AWS region to deploy resources"
  default     = "eu-central-1"
}

variable "availability_zone" {
  default = "eu-central-1a"
}
variable "availability_zone_b" {
  default = "eu-central-1b"
}
variable "cidr_pvc" {
  default = "192.168.0.0/24"
}
variable "cidr_subnet_public" {
  default = "192.168.0.0/25"
}
variable "cidr_subnet_private_a" {
  default = "192.168.0.128/26"
}
variable "cidr_subnet_private_b" {
  default = "192.168.0.192/26"
}
variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t3.micro"
}
variable "ami_id_web" {
  description = "AMI ID for the EC2 instances debian 12"
  default     = "ami-0035c2ac43dbd538f"
}
variable "user_data_app" {
  description = "Path to the user data script"
  default     = "./scripts/app.sh"
}
variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default = {
    env = "test"
  }
}