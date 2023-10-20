output "wp_intern_ip" {
  value = google_compute_instance.wp.network_interface[0].network_ip
}

output "db_intern_ip" {
  value = google_compute_instance.db.network_ip
}

output "wp_ip" {
  value = google_compute_address.wp_ip.address
}