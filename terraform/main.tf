provider "google" {
  project     = var.project_name
  region      = var.region
  credentials  = var-file.credentials
}

data "google_client_openid_userinfo" "me" {
}

resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
}

resource "google_compute_subnetwork" "subnet" {  
  name          = "subnet-wp"  
  ip_cidr_range = "10.0.0.0/24"  
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_firewall" "fw" {
  project     = var.project_name
  name    = "${var.project_name}-firewall"
  network = google_compute_network.vpc_network.self_link
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
}

resource "google_service_account" "service_account" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

# Instance pour Wordpress
resource "google_compute_instance" "wp" {  
  name         = "wordpress-${var.project_name}"  
  machine_type = "e2-small"  
  zone         = "${var.region}-${var.zone}"
  tags         = ["wp"]
  allow_stopping_for_update = true
  boot_disk {    
    initialize_params {      
      image = "ubuntu-os-cloud/ubuntu-2004-lts"     
    }  
  }  
  network_interface {    
    network = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.subnet.self_link 
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${split("@", data.google_client_openid_userinfo.me.email)[0]}:${file("~/.ssh/id_rsa.pub")}"
  }

  service_account {    
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.    
    email  = google_service_account.service_account.email
    scopes = ["cloud-platform"]  
  }
}

# Ip public wordpress
resource "google_compute_address" "wp_ip" {
  name = "wordpress-ip"
}

# Instance pour la base de données
resource "google_compute_instance" "db" {  
  name         = "db-${var.project_name}"   
  machine_type = "e2-small"  
  zone         = "${var.region}-${var.zone}"  
  tags         = ["db"]
  allow_stopping_for_update = true
  boot_disk {    
    initialize_params {      
      image = "ubuntu-os-cloud/ubuntu-2004-lts"    
    }  
  }  
  network_interface {    
    network = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.subnet.self_link 
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${split("@", data.google_client_openid_userinfo.me.email)[0]}:${file("~/.ssh/id_rsa.pub")}"
  }

  service_account {    
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.    
    email  = google_service_account.service_account.email
    scopes = ["cloud-platform"]  
  }
}