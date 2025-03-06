output "public_ip" {
  value = aws_instance.web.public_ip
}

output "private_ip" {
  value = aws_instance.web.private_ip
}

output "public_dns" {
  value = aws_instance.web.public_dns
}

output "user_data" {
  value = aws_instance.web.user_data
}