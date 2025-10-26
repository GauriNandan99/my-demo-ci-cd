packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable demo_nop_artifact {
    type = string
    default = "nopCommerce.zip"
}

variable buildid {
    type = string
    default = "v.1.0"
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "demo-np-${var.buildid}"
  instance_type = "t3.micro"
  region        = "ap-south-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "demo-np-${var.buildid}"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "file" {
  source = "nopCommerce.service"
  destination = "/tmp/nopCommerce.service"
}
  provisioner "file" {
  source = var.demo_nop_artifact
  destination = "/tmp/nopCommerce.zip"
}
  provisioner "shell" {
    script = "installnopscript.sh"
  }
  
}
