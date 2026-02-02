output "vcn_id" {
  value = oci_core_vcn.vcn.id

}

output "bastion_subnet_id" {
  value = oci_core_subnet.bastion_subnet.id

}

output "ig_id" {
  value = oci_core_internet_gateway.igw.id

}

output "database_subnet_id" {
  value = oci_core_subnet.database_subnet.id
}

output "application_subnet_id" {
  value = oci_core_subnet.application_subnet.id

}

output "loadbalancer_subnet_id" {
  value = oci_core_subnet.loadbalancer_subnet.id

}

output "oke_subnet_id" {
  value = oci_core_subnet.oke_subnet.id

}

output "db_cidr" {
  value = oci_core_subnet.database_subnet.cidr_block
}

output "nsg_oke" {
  value = oci_core_network_security_group.oke_nsg.id
}

output "nsg_app" {
  value = oci_core_network_security_group.app_nsg.id
}

output "osn_cidr_debug" {
  value = data.oci_core_services.osn.services[0].cidr_block
}

output "storage_subnet_ocid" {
  value = oci_core_subnet.storage_subnet.id
}

output "nsg_fss" {
  value = oci_core_network_security_group.fss_nsg.id
}

output "dbsubnetdomain" {
  value = oci_core_subnet.database_subnet.subnet_domain_name
}

output "app_cidr" {
  value = oci_core_subnet.application_subnet.cidr_block
}
