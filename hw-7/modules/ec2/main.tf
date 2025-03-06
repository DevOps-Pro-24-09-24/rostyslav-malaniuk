# Create EC2 instance for the web server

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name               = var.key_name

  user_data = templatefile("${path.module}/user_data.sh", {
    rds_endpoint   = var.rds_endpoint
    mysql_user     = var.db_user
    mysql_password = var.db_password
    mysql_db       = var.db_name
    flask_config   = "mysql"
    nginx_config = templatefile("${path.module}/nginx.conf.tpl", {
      web_instance_dns = "_PLACEHOLDER_"
    })
  })

  tags = {
    Name = "web-instance"
  }
}