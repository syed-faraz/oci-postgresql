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
// Oracle-Linux-7.6-2019.03.22-1
variable "images" {
  type = "map"

  default = {
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaydd7mt37cpouxlq2zreiiy2xauebkcwv7g3nqwziisdjenc2sz5a"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaajnvrzitemn2k5gfkfq2hwfs4bid577u2jbrzla42wxo2qc77gwxa"
    us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaa6fy4rewjwz2kanrc47fnei5xhfsrpmei2fwfepff3drzmsexznpq"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaa3rebuz4fyupv2xgdsdhtoiu5aiunl7pb76hfqqevoutnxznjn5ua"
    ca-toronto-1   = "ocid1.image.oc1.ca-toronto-1.aaaaaaaaq4fdhvuv5ylctfsjdvcfavcu233i4nkpw2zbd6bowolvi6uf3cwq"
  }
}
