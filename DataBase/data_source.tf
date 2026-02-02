data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}


data "oci_database_databases" "dbs" {
  compartment_id = var.database_compartment_id
  db_home_id     = oci_database_db_system.db_vm.db_home[0].id
}