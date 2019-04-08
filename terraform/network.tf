resource "oci_core_virtual_network" "PostgreSQLVCN" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "PostgreSQLCN"
  dns_label      = "postgresvcn"
}

resource "oci_core_subnet" "PostgreSQLSubnet" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1],"name")}"
  cidr_block          = "10.1.20.0/24"
  display_name        = "PostgreSQLSubnet"
  dns_label           = "postgressubnet"
  security_list_ids   = ["${oci_core_security_list.PostgreSQLSecurityList.id}"]
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.PostgreSQLVCN.id}"
  route_table_id      = "${oci_core_route_table.PostgreSQLRT.id}"
  dhcp_options_id     = "${oci_core_virtual_network.PostgreSQLVCN.default_dhcp_options_id}"
}

resource "oci_core_internet_gateway" "PostgreSQLIG" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "PostgreSQLIG"
  vcn_id         = "${oci_core_virtual_network.PostgreSQLVCN.id}"
}

resource "oci_core_route_table" "PostgreSQLRT" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.PostgreSQLVCN.id}"
  display_name   = "PostgreSQLRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.PostgreSQLIG.id}"
  }
}
