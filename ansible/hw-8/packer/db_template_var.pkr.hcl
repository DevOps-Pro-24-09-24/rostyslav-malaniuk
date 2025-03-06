packer {
  required_plugins {
    ansible = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "db_user" {
  type    = string
}
variable "db_pass" {
  type    = string
}
variable "db_name" {
  type    = string
}
variable "instance_size" {
  type    = string
}
variable "region" {
  type    = string
}
variable "base_ami" {
  type    = string
}
variable "ssh_username" {
  type    = string
}

source "amazon-ebs" "db" {
  instance_type = var.instance_size
  region        = var.region
  source_ami    = var.base_ami
  ssh_username = var.ssh_username
  ami_name      = "db-ami-ansible"
}

build {
  name    = "db-image"
  sources = ["source.amazon-ebs.db"]

  provisioner "ansible" {
    user          = "ubuntu"
    playbook_file = "../ansible/db_install.yml"
    extra_arguments = [
      "--extra-vars",
      "mysql_user=${var.db_user} mysql_pass=${var.db_pass} mysql_db=${var.db_name}"
    ]
  }
}
