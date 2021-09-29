## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_volume" "postgresql_master_volume" {
  count               = var.add_iscsi_volume ? 1 : 0
  availability_domain = var.availablity_domain_name
  compartment_id      = var.compartment_ocid
  display_name        = "PostgreSQL_Master_Volume"
  size_in_gbs         = var.iscsi_volume_size_in_gbs
  defined_tags        = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_volume_attachment" "postgresql_master_volume_attachment" {
  count           = var.add_iscsi_volume ? 1 : 0
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.postgresql_master.id
  volume_id       = oci_core_volume.postgresql_master_volume[0].id
}

resource "oci_core_volume" "postgresql_hotstandby1_volume" {
  count               = (var.postgresql_deploy_hotstandby1 && var.add_iscsi_volume) ? 1 : 0
  availability_domain = var.postgresql_hotstandby1_ad == "" ? var.availablity_domain_name : var.postgresql_hotstandby1_ad
  compartment_id      = var.compartment_ocid
  display_name        = "PostgreSQL_HotStandby1_Volume"
  size_in_gbs         = var.iscsi_volume_size_in_gbs
  defined_tags        = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_volume_attachment" "postgresql_hotstandby1_volume_attachment" {
  count           = (var.postgresql_deploy_hotstandby1 && var.add_iscsi_volume) ? 1 : 0
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.postgresql_hotstandby1[0].id
  volume_id       = oci_core_volume.postgresql_hotstandby1_volume[0].id
}

resource "oci_core_volume" "postgresql_hotstandby2_volume" {
  count               = (var.postgresql_deploy_hotstandby2 && var.add_iscsi_volume) ? 1 : 0
  availability_domain = var.postgresql_hotstandby2_ad == "" ? var.availablity_domain_name : var.postgresql_hotstandby2_ad
  compartment_id      = var.compartment_ocid
  display_name        = "PostgreSQL_HotStandby2_Volume"
  size_in_gbs         = var.iscsi_volume_size_in_gbs
  defined_tags        = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_volume_attachment" "postgresql_hotstandby2_volume_attachment" {
  count           = (var.postgresql_deploy_hotstandby2 && var.add_iscsi_volume) ? 1 : 0
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.postgresql_hotstandby2[0].id
  volume_id       = oci_core_volume.postgresql_hotstandby2_volume[0].id
}
