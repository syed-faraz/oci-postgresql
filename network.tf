resource "oci_core_virtual_network" "postgresql_vcn" {
  cidr_block     = var.postgresql_vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = "PostgreSQLCN"
  dns_label      = "postgresvcn"
}

resource "oci_core_subnet" "postgresql_subnet" {
  availability_domain = var.availablity_domain_name
  cidr_block          = var.postgresql_subnet_cidr
  display_name        = "PostgreSQLSubnet"
  dns_label           = "postgressubnet"
  security_list_ids   = [oci_core_security_list.postgresql_securitylist.id]
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.postgresql_vcn.id
  route_table_id      = oci_core_route_table.postgresql_rt.id
  dhcp_options_id     = oci_core_virtual_network.postgresql_vcn.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "postgresql_igw" {
  compartment_id = var.compartment_ocid
  display_name   = "PostgreSQLIGW"
  vcn_id         = oci_core_virtual_network.postgresql_vcn.id
}

resource "oci_core_route_table" "postgresql_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.postgresql_vcn.id
  display_name   = "PostgreSQLRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.postgresql_igw.id
  }
}
