provider "google" {
  project     = "future-oasis-399813"
  region      = "europe-west1"
  credentials  = file("../credentials.json")
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
  name    = "m2i-tp1-firewall"
  network = google_compute_network.vpc_network.self_link
  source_ranges = ["10.0.0.0/24"]
  allow {
    protocol = "tcp"
    ports    = ["22","80", "443"]
  }
}

# Instance pour Wordpress
resource "google_compute_instance" "wp" {  
  name         = "wordpress-m2i-tp1"  
  machine_type = "e2-small"  
  zone         = "europe-west1-b"
  tags         = ["wp"]
  boot_disk {    
    initialize_params {      
      image = "debian-cloud/debian-10"     
    }  
  }  
  network_interface {    
    network = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.subnet.self_link 
    access_config {
    }
  }
}

# Ip public wordpress
resource "google_compute_address" "wp_ip" {
  name = "wordpress-ip"
}

# Instance pour la base de données
resource "google_compute_instance" "db" {  
  name         = "db-m2i-tp1"   
  machine_type = "e2-small"  
  zone         = "europe-west1-b"  
  tags         = ["db"]
  boot_disk {    
    initialize_params {      
      image = "debian-cloud/debian-10"    
    }  
  }  
  network_interface {    
    network = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.subnet.self_link 
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
}