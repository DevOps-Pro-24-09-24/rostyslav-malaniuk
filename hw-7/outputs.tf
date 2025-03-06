# Output variables
output "web_public_ip" {
  value = module.ec2.public_ip
}

output "web_private_ip" {
  value = module.ec2.private_ip
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "web_instance_dns" {
  value = module.ec2.public_dns
}
