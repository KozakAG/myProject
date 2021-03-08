// Create instance docker

	resource "google_compute_address" "docker" {
		name = "ipv4-docker"
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
        network = google_compute_network.vpc.name
		subnetwork = google_compute_subnetwork.subnet.name
        access_config {
			nat_ip = google_compute_address.docker.address
        }
    }

	metadata = {ssh-keys = "agcossack:${file("c:/Users/Asgard/.ssh/id_rsa.pub")}"}
    connection {
      type = "ssh"
      user = "agcossack"
      host = "${google_compute_instance.docker.network_interface.0.access_config.0.nat_ip}"
      private_key = "${file("c:/Users/Asgard/.ssh/id_rsa")}"
      agent = false
    }
  provisioner "file" {
    source      = "docker.sh"
    destination = "/tmp/docker.sh"

  }
  provisioner "remote-exec" {
      inline = [
        "chmod +x /tmp/docker.sh",
        "/tmp/docker.sh",
      ]

    }
}
