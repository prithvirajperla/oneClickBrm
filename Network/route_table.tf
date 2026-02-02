
#DEFAULT-ROUTE_TABLE
resource "oci_core_route_table" "public_rt" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "public-rt"

  route_rules {
    destination       = "0.0.0.0/0" # all traffic
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }

}

#STORAGE-ROUTE_TABLE
resource "oci_core_route_table" "storage_private_rt" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "storage-private-rt"

  route_rules {
    destination       = "0.0.0.0/0" # all traffic
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat.id
  }
  route_rules {
    description       = "OCI Services via Service Gateway"
    destination_type  = "SERVICE_CIDR_BLOCK"
    destination       = data.oci_core_services.osn.services[0].cidr_block
    network_entity_id = oci_core_service_gateway.sg.id
  }
}

#PRIVATE-ROUTE_TABLE
resource "oci_core_route_table" "private_rt" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "private-rt"

  route_rules {
    destination       = "0.0.0.0/0" # all traffic
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat.id
  }
  route_rules {
    description       = "OCI Services via Service Gateway"
    destination_type  = "SERVICE_CIDR_BLOCK"
    destination       = data.oci_core_services.osn.services[0].cidr_block
    network_entity_id = oci_core_service_gateway.sg.id
  }
}

#DATABASE-ROUTE_TABLE
resource "oci_core_route_table" "db_rt_private" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "db-private-route-table"

  # 1. Added NAT Gateway Rule 
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat.id
  }

  # 2. Added Service Gateway Rule
  route_rules {
    destination       = data.oci_core_services.osn.services[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.sg.id
  }
}

#APPLICATION-ROUTE_TABLE
resource "oci_core_route_table" "app_subnet_rt" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "app-subnet-rt"

  # Route for General Internet Traffic
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat.id
  }

  # Route for Oracle Services (Object Storage, Streaming, etc.)
  route_rules {
    destination       = data.oci_core_services.osn.services[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.sg.id
  }
}


#OKE-ROUTE_TABLE
resource "oci_core_route_table" "oke_subnet_rt" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "oke-subnet-rt"

  # 1. Added NAT Gateway Rule 
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat.id
  }

  # 2. Added Service Gateway Rule
  route_rules {
    destination       = data.oci_core_services.osn.services[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.sg.id
  }
}
