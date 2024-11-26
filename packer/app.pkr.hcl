packer {
  required_plugins {
    amazon = {
      version = "~> 1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "app" {
  region        = "${var.region}"
  instance_type = "${var.instance_size}"
  source_ami    = "${var.base_ami}"
  ami_name      = "my-awesome-app-ami-for-aws"
  ssh_username  = "ubuntu"
  ssh_timeout   = "20m"

  tags = {
    Name        = "App"
    Environment = "Dev"
  }
}

build {
  sources = ["source.amazon-ebs.app"]

  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt-get install -y git nginx python3-pip"
    ]
  }
}
