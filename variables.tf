variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

variable "compartment_ocid" {}
variable "ssh_public_key" {}

# Defines the number of instances to deploy
variable "NumInstances" {
  default = "1"
}

# Choose an Availability Domain
variable "availability_domain" {
  default = "1"
}

variable "instance_shape" {
  default = "VM.Standard2.2"
}

variable "password" {
  default = ""
}

// https://docs.cloud.oracle.com/iaas/images/image/cf34ce27-e82d-4c1a-93e6-e55103f90164/
// Oracle-Linux-7.6-2019.03.22-0
variable "images" {
  type = "map"

  default = {
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaandary2dpwhw42xgv2d3zsbax2hln4wgcrm2tulo3dg67mwkly6aq"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaavzrrzlq2zvj5fd5c27jed7fwou5aqkezxbtmys4aolls54zg7f7q"
    us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaacvcy3avanrdb4ida456dgktfhab2phyaikmw75yflugq37eu6oya"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaajsuyctwgcvgfkqar2m7znxj25oqwkb7a7tucnrp2adbzoajasspq"
    ca-toronto-1   = "ocid1.image.oc1.ca-toronto-1.aaaaaaaalbg6mthxa6jjmwxb2477px4xb3azu4fl7kubp54s4rrvtswqmo6q"
  }
}
