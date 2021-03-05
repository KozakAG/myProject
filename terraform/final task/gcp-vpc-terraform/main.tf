// Configure the Google Cloud provider
	provider "google" {
	 credentials = "${file("${var.credentials}")}"
	 project     = "${var.gcp_project}" 
	 region      = "${var.region}"
	 zone        = "${var.zone}"
	}

	// Create VPC
	resource "google_compute_network" "vpc" {
	 name                    = "${var.name}-vpc"
	 auto_create_subnetworks = "false"
	}

// Create Subnet
	resource "google_compute_subnetwork" "subnet" {
	 name          = "${var.name}-subnet"
	 ip_cidr_range = "${var.subnet_cidr}"
	 network       = "${var.name}-vpc"
	 depends_on    = [google_compute_network.vpc]
	 region      = "${var.region}"
	}
// VPC firewall configuration
	resource "google_compute_firewall" "firewall" {
	  name    = "${var.name}-firewall"
	  network = google_compute_network.vpc.name

	  allow {
		protocol = "tcp"
		ports    = ["22","80","8080"]
	  }

	  source_ranges = ["0.0.0.0/0"]
	}

	resource "google_compute_address" "static" {
		name = "ipv4-address"
	}
// Create instance docker

// Create instance jenkins


	resource "google_compute_instance" "jenkins" {
		name         = "jenkins"

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
			nat_ip = google_compute_address.static.address
        }
    }

	metadata = {ssh-keys = "agcossack:${file("c:/Users/Asgard/.ssh/id_rsa.pub")}"}
    connection {
      type = "ssh"
      user = "agcossack"
      host = "${google_compute_instance.jenkins.network_interface.0.access_config.0.nat_ip}"
      private_key = "${file("c:/Users/Asgard/.ssh/id_rsa")}"
      agent = false
    }
  provisioner "file" {
    source      = "jenkins.sh"
    destination = "/tmp/jenkins.sh"

  }
  provisioner "remote-exec" {
      inline = [
        "chmod +x /tmp/jenkins.sh",
        "/tmp/jenkins.sh",
      ]

    }
}