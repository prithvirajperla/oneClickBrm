resource "oci_core_vcn" "vcn" {
  compartment_id = var.network_compartment_id
  cidr_block     = var.vcn_cidr
  display_name   = var.display_name
  dns_label      = "brmvcn"
}