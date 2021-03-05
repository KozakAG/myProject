provider "google" {

  credentials = "${file("c:/Users/Asgard/.my_key/kozak-305118-5a0aa2154936.json ")}"
  project     = "kozak-305118"
  region      = "europe-west2"
  zone        = "europe-west2-b"
}

resource "google_compute_instance" "docker" {
  name         = "docker"

	machine_type = "g1-small"


	boot_disk {
		initialize_params{
			size  = "20"
      type  = "pd-ssd"
      image = "ubuntu-1804-bionic-v20200807"
		}
	}
    network_interface {
        network = "default"
        access_config {

        }
    }
    metadata = { ssh-keys = "agcossack:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQM/4q90e4+rjzA6Q3RXAFc7G50j/y8wkFm1F2nz9ARomz/Cm5at9Xr1isA8tgfzeOS0agTb4VlLteWKItiQ1NIKla5rnC+D25jEK/D4tguPigY6xJ/ESzj1e5k2+0ubrrpRFmT0u99dFeGHUjHGq98hu6+yNos8cS7rP+bG1c2t3XAdZ8kR1j1bClmRlu6+6EW3DfR6jpenDj7kUbjixUNCnz5+cMAO7DM4Uunz4KZsq4gZCosqt4h6490UnjGAFoquvjcmNmBWsCnS/OiqWY9C1ebpTM2pkOzDNbL2mSrAPXFi4L6nYztd2J3nURtsBnytLZ3zRGen4hakhVj20YMsbVjIWd9fLc0RrP1S5AFX2SF1ACR2RtVCkZar6OoZYTdjx3CtUoDABcTZE9fswnaXlilfD4aEQ6cjpRy7VlbJLFvUZ/6QcbGiKXR1koCimxSv6Q6wi9S5McFqL9RKYUGhVScA+Plv7RrI9Frr0tUYOpwstuq8XoxA5oC32LVb/kFG1n9uhW0rLw1gI3fDPsVJ6YmJ7FiRiz0w6WeINuLXh5c7jr2Sirn+dpVtjLguRwEdTLDQ54tysBZkYsMamrMlDqHD0T3JMj/Vb3XsGeX/QzW43MfWy9heIsBCiwQwlzjDe3Sd/zryAQWwpt38o61As3oPeb84Aoen2UaUtIZw== agcossack@gmail.com" }

    connection {
      type = "ssh"
      user = "agcossack"
      host = "${google_compute_instance.docker.network_interface.0.access_config.0.nat_ip}"
      private_key = "${file("c:/Users/Asgard/.ssh/id_rsa")}"
      agent = false
    }
  provisioner "file" {
    source      = "docker.sh"
    destination = "/tmp/docker"

  }
  provisioner "remote-exec" {
      inline = [
        "chmod +x /tmp/docker.sh",
        "/tmp/docker.sh",
      ]

    }
  }  