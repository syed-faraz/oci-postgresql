resource "oci_core_instance" "postgresql_master" {
  availability_domain = var.availablity_domain_name
  compartment_id      = var.compartment_ocid
  display_name        = "PostgreSQL_Master"
  shape               = var.postgresql_instance_shape
  fault_domain        = var.postgresql_master_fd

  create_vnic_details {
    subnet_id        = oci_core_subnet.postgresql_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "pgmaster"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.InstanceImageOCID.images[0].id
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
  }
}

resource "oci_core_instance" "postgresql_hotstandby1" {
  count               = var.postgresql_deploy_hotstandby1 ? 1 : 0
  availability_domain = var.postgresql_hotstandby1_ad
  compartment_id      = var.compartment_ocid
  display_name        = "PostgreSQL_HotStandby1"
  shape               = var.postgresql_hotstandby1_shape
  fault_domain        = var.postgresql_hotstandby1_fd

  create_vnic_details {
    subnet_id        = oci_core_subnet.postgresql_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "pgstandby1"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.InstanceImageOCID.images[0].id
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
  }
}

resource "oci_core_instance" "postgresql_hotstandby2" {
  count               = var.postgresql_deploy_hotstandby2 ? 1 : 0
  availability_domain = var.postgresql_hotstandby2_ad
  compartment_id      = var.compartment_ocid
  display_name        = "PostgreSQL_HotStandby2"
  shape               = var.postgresql_hotstandby2_shape
  fault_domain        = var.postgresql_hotstandby2_fd

  create_vnic_details {
    subnet_id        = oci_core_subnet.postgresql_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "pgstandby2"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.InstanceImageOCID.images[0].id
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
  }
}
