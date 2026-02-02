#Internet Gateway
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "internet-gateway"
  enabled        = true
}

# NAT Gateway (for private subnets)
resource "oci_core_nat_gateway" "nat" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "nat-gateway"
}

# Service Gateway
resource "oci_core_service_gateway" "sg" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "oke-service-gateway"

  services {
    service_id = data.oci_core_services.osn.services[0].id
  }
}