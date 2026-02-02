

#OKE-CLUSTER
resource "oci_containerengine_cluster" "cluster" {
  name               = "oke-cluster"
  compartment_id     = var.compute_compartment_id
  kubernetes_version = var.kube_version

  endpoint_config {
    # By specifying the subnet_id here, the control plane endpoint is placed in the OKE subnet
    subnet_id            = var.oke_subnet_id
    is_public_ip_enabled = false
    nsg_ids              = [var.nsg_oke]
  }

  # Networking
  vcn_id = var.vcn_id

  # Optional addons & config (concise; adjust as needed)
  options {
    service_lb_subnet_ids = [var.loadbalancer_subnet_id] # Use app subnet for Service LB (can split if desired)
    kubernetes_network_config {
      pods_cidr     = "10.244.0.0/16"
      services_cidr = "10.96.0.0/16"
    }

  }
}


#NODE-POOL
resource "oci_containerengine_node_pool" "node_pool" {
  name               = "worker-nodepool"
  compartment_id     = var.compute_compartment_id
  cluster_id         = oci_containerengine_cluster.cluster.id
  kubernetes_version = var.kube_version

  initial_node_labels {

    key   = "env"
    value = "cts"
  }


  node_config_details {


    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = var.application_subnet_id

    }
    size    = 3
    nsg_ids = [var.nsg_app]


  }

  node_shape = "VM.Standard.E3.Flex"

  node_shape_config {
    ocpus         = 4
    memory_in_gbs = 16
  }

  node_source_details {
    source_type             = "IMAGE"
    image_id                = local.target_image_ocid
    boot_volume_size_in_gbs = 100
  }



  ssh_public_key = tls_private_key.bastion_key.public_key_openssh
}
