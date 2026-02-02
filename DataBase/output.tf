
output "db_private_ip" {
  value = oci_database_db_system.db_vm.private_ip

}

output "pdb_connect_string" {
  value = data.oci_database_databases.dbs.databases[0].connection_strings[0]
}

output "dbhostname" {
  value = oci_database_db_system.db_vm.hostname
}
