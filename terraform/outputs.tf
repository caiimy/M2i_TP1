output "wp_ip" {
  value = google_compute_address.wp_ip.address
}

output "wp" {
  value = google_compute_instance.wp.network_interface[0].access_config[0].nat_ip
}

output "db" {
  value = google_compute_instance.db.network_interface[0].access_config[0].nat_ip
}