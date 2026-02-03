provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region

}

module "vcn" {

  source                 = "./Network"
  network_compartment_id = var.network_compartment_id
  vcn_cidr               = var.vcn_cidr
  display_name           = var.display_name
  #compartment_ocid         = var.compartment_ocid
  storage_compartment_ocid = var.storage_compartment_ocid
  compute_compartment      = var.compute_compartment_id
  #tenancy_ocid             = var.tenancy_ocid

}

module "compute" {

  #bastion
  source                 = "./Compute"
  compute_compartment_id = var.compute_compartment_id
  tenancy_ocid           = var.tenancy_ocid
  vcn_id                 = module.vcn.vcn_id
  subnet_id              = module.vcn.bastion_subnet_id
  application_subnet_id  = module.vcn.application_subnet_id
  bastion_img_id         = var.bastion_img_id
  bastion_display_name   = var.bastion_display_name
  bastion_shape          = var.bastion_shape
  custom_rsa_key         = var.custom_rsa_key
  pub_rsa_key_path       = var.pub_rsa_key_path

  #-dbconfig
  db_private_ip     = module.db.db_private_ip
  db_admin_password = var.db_admin_password
  dbsubnetdomain    = module.vcn.dbsubnetdomain
  dbhostname        = module.db.dbhostname

  #--initdbconfig
  pinpass  = var.pinpass
  pdb_name = var.pdb_name


  #-ociConfig
  private_key_path = var.private_key_path
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  region           = var.region

  #-OKEconfig
  app_cidr               = module.vcn.app_cidr
  loadbalancer_subnet_id = module.vcn.loadbalancer_subnet_id
  oke_subnet_id          = module.vcn.oke_subnet_id
  kube_version           = var.kube_version
  nsg_app                = module.vcn.nsg_app
  nsg_oke                = module.vcn.nsg_oke

  #-FileStorageConfig
  mnt_avd         = module.Storage.fss_ad
  mnt_id          = module.Storage.fss_mnt_target_id
  mnt_compartment = module.Storage.fss_mnt_compartment

  #-secretConfig
  dockerServer   = var.dockerServer
  dockerUsername = var.dockerUsername
  dockerPass     = var.dockerPass
  dockeremail    = var.dockeremail
  dNamespace     = var.dNamespace
}


module "db" {
  source                  = "./DataBase"
  database_compartment_id = var.database_compartment_id
  db_admin_password       = var.db_admin_password
  tenancy_ocid            = var.tenancy_ocid
  db_subnet_id            = module.vcn.database_subnet_id
  public_key_pem          = module.compute.rsa_public_key
  db_cidr                 = module.vcn.db_cidr
  db_display_name         = var.db_display_name
  db_vm_shape             = var.db_vm_shape
  pdb_name                = var.pdb_name
  dbsubnetdomain          = module.vcn.dbsubnetdomain
  availability_domain     = data.oci_identity_availability_domains.ads.availability_domains[0].name
}

module "Storage" {
  source                   = "./Storage"
  availability_domain      = data.oci_identity_availability_domains.ads.availability_domains[0].name
  storage_compartment_ocid = var.storage_compartment_ocid
  storage_subnet_ocid      = module.vcn.storage_subnet_ocid
  nsg_fss_id               = module.vcn.nsg_fss
}
