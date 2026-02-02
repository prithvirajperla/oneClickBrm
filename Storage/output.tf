output "fss_ad" {
  value = oci_file_storage_mount_target.brm_fs_mt.availability_domain
}
output "fss_mnt_target_id" {
  value = oci_file_storage_mount_target.brm_fs_mt.id
}
output "fss_mnt_compartment" {
  value = oci_file_storage_mount_target.brm_fs_mt.compartment_id
}
