output "web_instance_public_ip" {
  description = "Public IP of the WEB instance"
  value       = "${aws_instance.web.public_ip}"
}

output "web_instance_private_ip" {
  description = "Private IP of the WEB instance"
  value       = "${aws_instance.web.private_ip}"
}

output "db_instance_private_ip" {
  description = "Private IP of the DB instance"
  value       = "${aws_instance.db.private_ip}"
}

output "app_instance_dns" {
  description = "DNS name of the app instance"
  value       = "${aws_instance.web.public_dns}"
}
