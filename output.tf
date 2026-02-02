
#Network




#Db
output "dbConnectString" {
  value = "sqlplus sys/${var.db_admin_password}@//${module.db.db_private_ip}:1521/${lower(var.pdb_name)}.${module.db.dbhostname} as sysdba"

}



#Compute
output "bastion_ip" {
  value = module.compute.bastion_ip
}



#FileStorage


