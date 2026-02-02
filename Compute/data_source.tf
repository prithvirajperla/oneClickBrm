data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}
data "oci_containerengine_cluster_kube_config" "oke_kubeconfig" {
  cluster_id    = oci_containerengine_cluster.cluster.id
  token_version = "2.0.0"
}
data "oci_containerengine_node_pool_option" "oke_options" {
  node_pool_option_id = "all"
  compartment_id      = var.compute_compartment_id
  # Can be any compartment
}



