#BASTION-SUBNET
resource "oci_core_subnet" "bastion_subnet" {

  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  dns_label      = "bastionsubnet"
  cidr_block     = cidrsubnet(var.vcn_cidr, 12, 0)
  display_name   = "Baiston_Subnet"
  route_table_id = oci_core_route_table.public_rt.id

}

#APPLICATION-SUBNET
resource "oci_core_subnet" "application_subnet" {

  compartment_id             = var.network_compartment_id
  vcn_id                     = oci_core_vcn.vcn.id
  dns_label                  = "appsubnet"
  cidr_block                 = cidrsubnet(var.vcn_cidr, 4, 1)
  display_name               = "Application_Subnet"
  prohibit_public_ip_on_vnic = true
  route_table_id             = oci_core_route_table.app_subnet_rt.id
}

#DATABASE-SUBNET
resource "oci_core_subnet" "database_subnet" {
  compartment_id             = var.network_compartment_id
  vcn_id                     = oci_core_vcn.vcn.id
  dns_label                  = "dbsubnet"
  cidr_block                 = cidrsubnet(var.vcn_cidr, 4, 2)
  display_name               = "Database_Subnet"
  prohibit_public_ip_on_vnic = true
  route_table_id             = oci_core_route_table.db_rt_private.id
  security_list_ids          = [oci_core_security_list.db_sl_private.id]
}

#LOAD_BALANCER-SUBNET
resource "oci_core_subnet" "loadbalancer_subnet" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  dns_label      = "lbsubnet"
  cidr_block     = cidrsubnet(var.vcn_cidr, 12, 3)
  display_name   = "Loadbalancer_Subnet"
  route_table_id = oci_core_route_table.private_rt.id
}

#STORAGE-SUBNET
resource "oci_core_subnet" "storage_subnet" {
  compartment_id             = var.network_compartment_id
  vcn_id                     = oci_core_vcn.vcn.id
  dns_label                  = "storagesubnet"
  cidr_block                 = cidrsubnet(var.vcn_cidr, 11, 4)
  display_name               = "storage_Subnet"
  prohibit_public_ip_on_vnic = true
  route_table_id             = oci_core_route_table.storage_private_rt.id
}

#OKE-SUBNET
resource "oci_core_subnet" "oke_subnet" {

  compartment_id             = var.network_compartment_id
  vcn_id                     = oci_core_vcn.vcn.id
  dns_label                  = "okesubnet"
  cidr_block                 = cidrsubnet(var.vcn_cidr, 12, 5)
  display_name               = "Oke_Subnet"
  prohibit_public_ip_on_vnic = true
  route_table_id             = oci_core_route_table.oke_subnet_rt.id
}