resource "oci_database_db_system" "db_vm" {
  compartment_id      = var.database_compartment_id
  availability_domain = var.availability_domain
  display_name        = var.db_display_name

  shape            = var.db_vm_shape # 1 OCPU VM shape
  database_edition = "ENTERPRISE_EDITION_HIGH_PERFORMANCE"

  subnet_id  = var.db_subnet_id
  private_ip = cidrhost(var.db_cidr, 10)
  # Required hostname
  hostname = "dbvm1"
  domain   = var.dbsubnetdomain
  timeouts {
    create = "4h" # wait up to 90 minutes
    update = "3h" # wait up to 60 minutes
    delete = "1h" # wait up to 30 minutes
  }

  db_home {
    db_version   = "19.29.0.0"
    display_name = "dbhome1"

    database {
      db_name        = "ORCL"
      pdb_name       = var.pdb_name
      admin_password = var.db_admin_password
      character_set  = "AL32UTF8"
      ncharacter_set = "AL16UTF16"
      db_workload    = "OLTP"
    }
  }

  ssh_public_keys         = [var.public_key_pem]
  data_storage_size_in_gb = 256
}

