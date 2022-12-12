terraform {
	required_providers {
		linode = {
			source = "linode/linode"
			version = "1.29.4"
		}
	}
}

variable "TOKEN" {
  description = "Linode Api Token"
}

provider "linode" {
  token = var.TOKEN
}

resource "linode_instance" "jenkins-agent" {
	image = "linode/ubuntu20.04"
	label = "AGENT-test"
	region = "ap-south"
	type = "g6-standard-2"
	swap_size = 2048
	root_pass = "terr4form@#"
	group = "BS"
  tags = [ "jenkins-agent" ]

	connection {
		host = self.ip_address
		user = "root"
		type = "ssh"
		password = "terr4form@#"
		timeout = "2m"
	}

	provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh get-docker.sh"
    ]
	}
}

output "instance_ip" {
  description = "IP of the instance"
  value       = linode_instance.jenkins-agent.ipv4
}
