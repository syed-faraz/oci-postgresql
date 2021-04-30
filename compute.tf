## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

data "template_file" "key_script" {
  template = file("./scripts/sshkey.tpl")
  vars = {
    ssh_public_key = tls_private_key.public_private_key_pair.public_key_openssh
  }
}

data "template_cloudinit_config" "cloud_init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "ainit.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.key_script.rendered
  }
}

resource "oci_core_instance" "postgresql_master" {
  availability_domain = var.availablity_domain_name
  compartment_id      = var.compartment_ocid
  display_name        = "PostgreSQL_Master"
  shape               = var.postgresql_instance_shape

  dynamic "shape_config" {
    for_each = local.is_flexible_postgresql_instance_shape ? [1] : []
    content {
      memory_in_gbs = var.postgresql_instance_flex_shape_memory
      ocpus = var.postgresql_instance_flex_shape_ocpus
    }
  }
  
  fault_domain        = var.postgresql_master_fd

  create_vnic_details {
    subnet_id        = oci_core_subnet.postgresql_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "pgmaster"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.InstanceImageOCID_postgresql_instance_shape.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = data.template_cloudinit_config.cloud_init.rendered
  }

  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_instance" "postgresql_hotstandby1" {
  count               = var.postgresql_deploy_hotstandby1 ? 1 : 0
  availability_domain = var.postgresql_hotstandby1_ad  == "" ? var.availablity_domain_name : var.postgresql_hotstandby1_ad 
  compartment_id      = var.compartment_ocid
  display_name        = "PostgreSQL_HotStandby1"
  shape               = var.postgresql_hotstandby1_shape

  dynamic "shape_config" {
    for_each = local.is_flexible_postgresql_hotstandby1_shape ? [1] : []
    content {
      memory_in_gbs = var.postgresql_hotstandby1_flex_shape_memory
      ocpus = var.postgresql_hotstandby1_flex_shape_ocpus
    }
  }
  
  fault_domain        = var.postgresql_hotstandby1_fd

  create_vnic_details {
    subnet_id        = oci_core_subnet.postgresql_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "pgstandby1"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.InstanceImageOCID_postgresql_hotstandby1_shape.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = data.template_cloudinit_config.cloud_init.rendered
  }

  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_instance" "postgresql_hotstandby2" {
  count               = var.postgresql_deploy_hotstandby2 ? 1 : 0
  availability_domain = var.postgresql_hotstandby2_ad  == "" ? var.availablity_domain_name : var.postgresql_hotstandby2_ad 
  compartment_id      = var.compartment_ocid
  display_name        = "PostgreSQL_HotStandby2"
  shape               = var.postgresql_hotstandby2_shape

  dynamic "shape_config" {
    for_each = local.is_flexible_postgresql_hotstandby2_shape ? [1] : []
    content {
      memory_in_gbs = var.postgresql_hotstandby2_flex_shape_memory
      ocpus = var.postgresql_hotstandby2_flex_shape_ocpus
    }
  }
  
  fault_domain        = var.postgresql_hotstandby2_fd

  create_vnic_details {
    subnet_id        = oci_core_subnet.postgresql_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "pgstandby2"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.InstanceImageOCID_postgresql_hotstandby2_shape.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = data.template_cloudinit_config.cloud_init.rendered
  }

  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
