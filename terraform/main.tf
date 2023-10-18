provider "google" {
  project     = "M2i-TP1"
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
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

# Instance pour Wordpress
resource "google_compute_instance" "wp" {  
  name         = "wordpress-M2i-TP1"  
  machine_type = "f1-micro"  
  zone         = "europe-west1-b"  
  boot_disk {    
    initialize_params {      
      image = "debian-cloud/debian-9"     
    }  
  }  
  network_interface {    
    subnetwork = google_compute_subnetwork.subnet.name  
  }
}

# Ip public wordpress
resource "google_compute_address" "ip_wordpress" {
  name = "wordpress-ip"
}

# Instance pour la base de données
resource "google_compute_instance" "db" {  
  name         = "db-M2i-TP1"   
  machine_type = "f1-micro"  
  zone         = "europe-west1-b"  
  boot_disk {    
    initialize_params {      
      image = "debian-cloud/debian-9"    
    }  
  }  
  network_interface {    
    subnetwork = google_compute_subnetwork.subnet.name  
  }
}