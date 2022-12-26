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
  default = "token_here"
}

variable "NAME" {
  description = "Linode Server Label"
  default = "Name"
}

variable "JENKINS_AGENT_SSH_PUBKEY" {
  description = "Public key ssh"
  default = "key"
}

provider "linode" {
  token = var.TOKEN
}

resource "linode_instance" "jenkins-agent" {
	image = "private/18278973"
	label = var.NAME
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
      "docker run -d --rm --name=agent --publish 2020:22 -v /var/run/docker.sock:/var/run/docker.sock -e 'JENKINS_AGENT_SSH_PUBKEY=var.JENKINS_AGENT_SSH_PUBKEY' rogerdz/jenkins:ssh-agent"
    ]
	}
}

output "instance_ip" {
  description = "IP of the instance"
  value       = linode_instance.jenkins-agent.ipv4
}
