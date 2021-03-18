output "PostgreSQL_Master_VM_public_IP" {
  value = data.oci_core_vnic.postgresql_master_primaryvnic.public_ip_address
}

output "PostgreSQL_HotStandby1_VM_public_IP" {
  value = element(data.oci_core_vnic.postgresql_hotstandby1_primaryvnic.*.public_ip_address,0)
}

output "PostgreSQL_HotStandby2_VM_public_IP" {
  value = element(data.oci_core_vnic.postgresql_hotstandby2_primaryvnic.*.public_ip_address,0)
}

output "PostgreSQL_Username" {
  value = "postgres"
}

output "generated_ssh_private_key" {
  value = tls_private_key.public_private_key_pair.private_key_pem
}
