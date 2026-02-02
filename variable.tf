#Provider
variable "user_ocid" {}
variable "fingerprint" {}
variable "api_key_path" {}
variable "region" {}



#Network
variable "network_compartment_id" {}
variable "display_name" {}
variable "vcn_cidr" {}
variable "storage_compartment_ocid" {}
#variable "compartment_ocid" {}
variable "compute_compartment_id" {}
variable "database_compartment_id" {}


#Compute
#bastion
variable "tenancy_ocid" {}
variable "bastion_img_id" {}
variable "bastion_shape" {
  type    = string
  default = "VM.Standard.E5.Flex"
}
variable "custom_rsa_key" {
  description = "Optional extra RSA public key"
  type        = string
  default     = null
}
variable "pub_rsa_key_path" {
  description = "Optional extra RSA public key path"
  type        = string
  default     = null
}
#-bastionConfig
variable "pinpass" {}
#--dockerSecret
variable "dockerServer" {
  type    = string
  default = "fra.ocir.io"
}
variable "dockerUsername" {
  type    = string
  default = "fry4fxlvxkjt/Default/sourav.bhadra@cognizant.com"
}
variable "dockerPass" {
  type    = string
  default = "}Schz}4bt]6Oa#aAA7LE"
}
variable "dockeremail" {
  type    = string
  default = "sourav.bhadra@cognizant.com"
}
variable "dNamespace" {
  type    = string
  default = "initdb"
}
#--oke
variable "kube_version" {
  type    = string
  default = "v1.33.1"
}
variable "bastion_display_name" {
  type    = string
  default = "bastion-vm"
}



#Database
variable "db_admin_password" {}
variable "db_display_name" {
  type    = string
  default = "db-system-vm"
}
variable "db_vm_shape" {
  type    = string
  default = "VM.Standard2.1"
}
variable "pdb_name" {
  type    = string
  default = "brmpdb"
}

variable "os_type" {}



#FileStorage


