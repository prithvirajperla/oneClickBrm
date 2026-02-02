resource "oci_file_storage_file_system" "brm_fs" {
  availability_domain = var.availability_domain
  compartment_id      = var.storage_compartment_ocid
  display_name        = "brm-fs"
}

#Mount Target
resource "oci_file_storage_mount_target" "brm_fs_mt" {
  availability_domain = var.availability_domain
  compartment_id      = var.storage_compartment_ocid
  subnet_id           = var.storage_subnet_ocid # FS subnet
  display_name        = "brm-fs-mt"
  nsg_ids             = [var.nsg_fss_id]
}

#Export
resource "oci_file_storage_export" "brm_fs_export" {
  export_set_id  = oci_file_storage_mount_target.brm_fs_mt.export_set_id
  file_system_id = oci_file_storage_file_system.brm_fs.id
  path           = "/brmfs"
  export_options {
    source          = "10.0.0.0/28" # Allow basiom (adjust for security)
    access          = "READ_WRITE"
    identity_squash = "NONE"
    anonymous_gid   = 65534
    anonymous_uid   = 65534
  }
  export_options {
    source          = "10.0.16.0/20" # Allow all oke nodepool (adjust for security)
    access          = "READ_WRITE"
    identity_squash = "NONE"
    anonymous_gid   = 65534
    anonymous_uid   = 65534
  }
}