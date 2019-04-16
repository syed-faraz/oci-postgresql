data "template_file" "postgresql" {
  template = "${file("../scripts/postgresql.sh")}"

  vars {
    password = "${local.password}"
  }
}

resource "oci_core_instance" "PostgreSQL" {
  count               = "${var.NumInstances}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "PostgreSQL-${count.index}"
  shape               = "${var.instance_shape}"

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.PostgreSQLSubnet.id}"
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "postgresql-${count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = "${var.images[var.region]}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(data.template_file.postgresql.rendered)}"
  }
}

resource "random_string" "mix" {
  length  = 8
  upper   = true
  lower   = true
  number  = true
  special = false
}

resource "random_string" "special" {
  length           = 1
  upper            = false
  lower            = false
  number           = false
  special          = true
  override_special = "#&*+"
}

resource "random_string" "number" {
  length  = 1
  upper   = false
  lower   = false
  number  = true
  special = false
}

locals {
  password = "${random_string.mix.result}${random_string.special.result}${random_string.number.result}"
}
