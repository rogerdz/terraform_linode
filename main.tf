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
	image = "private/20713472"
	label = var.NAME
	region = "ap-south"
	type = "g6-standard-1"
	swap_size = 4096
	root_pass = "h@8R#j8F7xfpXEmX"
	group = "BS"
  tags = [ "jenkins-agent" ]

	connection {
		host = self.ip_address
		user = "root"
		type = "ssh"
		password = "h@8R#j8F7xfpXEmX"
		timeout = "2m"
	}

	provisioner "remote-exec" {
    inline = [
      "docker run -d --rm --privileged --name=agent --publish 2020:22 -v /var/run/docker.sock:/var/run/docker.sock -e 'JENKINS_AGENT_SSH_PUBKEY=ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQjLY6AfojC5PFlQKJRwk3jhFblyHqEwLeldDhuuOxTyDSpIVs2pDo9NecHy3O/58Uo2bZ2Udw+9zkhYcjdbRD0iHWLnHMByrgUPFN1hnhiavKKSqNu2/LG6tfVq+9h1ANawST4sASBIH5pjGXGLe4qk9r+FeUX+gXkvp+NDQ6c4riAKJbBtdUbVC7PqOcWbeCHei+E4qP3zEd9gbfXHRG9QtzH1zf7/kSK8HxNl8Me6tI0qqhWACsTgdLmGksnEpwqBzTvzstHy/FHzhR/obmIGeXqsoPchBF1gcMwrC5C0ZSqSaTp40ukt+Qs+oIcyhN+t70KhQRKfr1Mtc+BGzWPQyXvWciiuJKDr/Fr2bu3Onwk9k8wco8H/SVhY852FgVSFhB0B28qUlyd3GbmI4pfy+Frypu5P3E5hJZXLQCvlnY9shytYoYbBo5Kr3I2npn2YdIpYvTvr60j52s2Hq2Xg3uxAr+ho3Hu8rwYSrP8uJchu0M/B0i9oAAfnYGl90= hieudang@hieudang' rogerdz/jenkins:ssh-agent"
    ]
	}
}

output "instance_ip" {
  description = "IP of the instance"
  value       = linode_instance.jenkins-agent.ipv4
}
