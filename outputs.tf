output "PostgreSQL VM public IP" {
  value = "${data.oci_core_vnic.postgresql_vnic.public_ip_address}"
}

output "PostgreSQL Username" {
  value = "postgres"
}

output "PostgreSQL Password" {
  value     = "${ var.password == "" ? local.password : "Password provided as input" }"
  sensitive = false
}
