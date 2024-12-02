source "amazon-ebs" "db" {
  region        = "${var.region}"
  instance_type = "${var.instance_size}"
  source_ami    = "${var.base_ami}"
  ami_name      = "my-awesome-db-ami-for-aws"
  ssh_username  = "ubuntu"
  ssh_timeout   = "20m"

  tags = {
    Name        = "DB"
    Environment = "Dev"
  }
}

build {
  sources = ["source.amazon-ebs.db"]

  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y mariadb-server",
      "sudo mysql -e \"CREATE USER 'admin'@'%' IDENTIFIED BY 'Pa55WD';\"",
      "sudo mysql -e \"CREATE DATABASE flask_db;\"",
      "sudo mysql -e \"GRANT ALL on flask_db.* TO 'admin'@'%';\"",
      "sudo systemctl enable mysql"
    ]
  }
}
