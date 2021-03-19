variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "availablity_domain_name" {}

variable "postgresql_vcn_cidr" {
  default = "10.1.0.0/16"
}

variable "postgresql_subnet_cidr" {
  default = "10.1.20.0/24"
}

variable "postgresql_instance_shape" {
  default = "VM.Standard2.1"
}

variable "instance_os" {
  description = "Operating system for compute instances"
  default     = "Oracle Linux"
}

variable "linux_os_version" {
  description = "Operating system version for all Linux instances"
  default     = "7.9"
}

variable "postgresql_master_fd" {
  default = "FAULT-DOMAIN-1"
}

variable "postgresql_replicat_username" {
  default = "replicator"
}

variable "postgresql_password" {
  default = ""
}

variable "postgresql_version" {
  default = "13"
}

variable "postgresql_deploy_hotstandby1" {
  default = false
}

variable "postgresql_hotstandby1_fd" {
  default = "FAULT-DOMAIN-2"
}

variable "postgresql_hotstandby1_ad" {
  default = ""
}

variable "postgresql_hotstandby1_shape" {
  default = "VM.Standard2.1"
}

variable "postgresql_deploy_hotstandby2" {
  default = false
}

variable "postgresql_hotstandby2_fd" {
  default = "FAULT-DOMAIN-3"
}

variable "postgresql_hotstandby2_ad" {
  default = ""
}

variable "postgresql_hotstandby2_shape" {
  default = "VM.Standard2.1"
}

