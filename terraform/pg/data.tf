data "oci_core_vcns" "parent_vcn" {
  compartment_id = "${var.compartment_ocid}"
  filter { name = "id" values = [ "${var.vcn_ocid}" ] }
}

data "oci_core_vnic_attachments" "pg_vnic_attachment" {
  compartment_id = "${var.compartment_ocid}"
  instance_id = "${oci_core_instance.pg_vm.id}"
}

data "oci_core_vnic" "pg_vnic" {
  vnic_id = "${data.oci_core_vnic_attachments.pg_vnic_attachment.vnic_attachments.0.vnic_id}"
}

output "pg_ip" { value = "${data.oci_core_vnic.pg_vnic.public_ip_address}" }

