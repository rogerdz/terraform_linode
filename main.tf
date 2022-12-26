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
      "docker run -d --rm --name=agent --publish 2020:22 -v /var/run/docker.sock:/var/run/docker.sock -e 'JENKINS_AGENT_SSH_PUBKEY=ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDG/U3Iyz299qasZxKWwWgx96Qfng4+s2zrwqwlZAuFRcmsRc1r10kSLDYmWUviJc0gjdu+4BrnGxx8CNG+7SuAh5I2MJXlquBrht29Xi72BZOjCn9eMmKg6OtybRDMCakpkf0Ji2I5oYinEip8IdBE8ZOM/C/l6t+0fmIlct8GSGknVvPBHglpuTbO9ow6pTM1XyNj+sUuzPLwyZq20B+aX+aUGfv+ryk1Y+zT7BPupKgQa0dm8lEOMHmR57iyFDe1PIzqM3PfDuDMOKnxIfTOQYTRIzi4Ve2fC4bMnReyfWcBjVHtrcmJUwxpJJBcQxkxfvo7hATT1vBP8dErGlT2PwKPTc1E90Plf/l44rWcVyLxgl9ISEQA/7nZnABD7xGKXUiEPNKlwl2xxKhqxgiQm1mA0YExqHqQ6LrV1MHMOmXN2orM/hsWXzU0BmXyGG/YxY9jWp5jzr1/fPhsQzWufJruD6uDhbAum2bMUPPVHcIBx8t8Js1mZTQo7UUvJTAHWUca7zlCfXoR86NWGdIyhZsCjL30tDf8H7GHHOVu8m0EbTTAzD71Se1viAvpgRD7jbmtIPXTnWBMQonWQDm0XBr3AW9ybvrZFSYf3DCJ483T8zAW/RR9WGUXTDjvW9oZk79aVK9gEsFPsn/idv82xSJAYR3TgbVUwTv6TCEjjQ== hieudang@hieudang' rogerdz/jenkins:ssh-agent"
    ]
	}
}

output "instance_ip" {
  description = "IP of the instance"
  value       = linode_instance.jenkins-agent.ipv4
}
