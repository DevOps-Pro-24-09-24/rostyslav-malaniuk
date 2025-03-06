packer {
  required_plugins {
    ansible = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "repo_url" {
  type    = string
}
variable "app_dir" {
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
variable "db_user" {
  type    = string
}
variable "db_pass" {
  type    = string
}
variable "db_name" {
  type    = string
}
variable "ssh_username" {
  type    = string
}

source "amazon-ebs" "app" {
  instance_type = var.instance_size
  region        = var.region
  source_ami    = var.base_ami
  ssh_username = var.ssh_username
  ami_name = "app-ami-ansible"
}

build {
  name    = "app-image"
  sources = ["source.amazon-ebs.app"]

  provisioner "ansible" {
    user          = "ubuntu"
    playbook_file = "../ansible/app_install.yml"
    #extra_arguments = ["-vvv"]
  }
  provisioner "ansible" {
    user          = "ubuntu"
    playbook_file = "../ansible/deploy.yml"
    extra_arguments = [
      "--extra-vars",
      "repo=${var.repo_url} dir=${var.app_dir}"
    ]
  }
}
