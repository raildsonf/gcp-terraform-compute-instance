resource "google_compute_address" "static" {
  name = "ipv4-address"
}

data "google_compute_image" "centos_image" {
  family  = "centos-7"
  project = "centos-cloud"
}

resource "google_compute_instance" "web" {
  name = "web-1"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.centos_image.self_link
    }
  }

  metadata_startup_script = "${file("scripts/web.sh")}"

  network_interface {
    network = "default"
    subnetwork = "default"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
  tags = ["http-server","https-server"]

}