#app nsg
# 1. Create the Network Security Group Container
resource "oci_core_network_security_group" "app_nsg" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "app-nsg"
}

# 2. Ingress Rule: Allow intra-VCN traffic
resource "oci_core_network_security_group_security_rule" "allow_intra_vcn" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                 = "INGRESS"
  protocol                  = "all" # All protocols
  source                    = var.vcn_cidr
  source_type               = "CIDR_BLOCK"
}

# 3. Ingress Rule: Allow NodePort services (30000-32767)
resource "oci_core_network_security_group_security_rule" "allow_nodeport" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = var.vcn_cidr
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 30000
      max = 32767
    }
  }
}

# 4. Ingress Rule: Allow SSH (Port 22) from specific management subnet
resource "oci_core_network_security_group_security_rule" "allow_ssh" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = oci_core_subnet.oke_subnet.cidr_block
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

# # 5. Egress Rule: Allow all outbound traffic
# resource "oci_core_network_security_group_security_rule" "allow_all_egress" {
#   network_security_group_id = oci_core_network_security_group.app_nsg.id
#   direction                 = "EGRESS"
#   protocol                  = "all"
#   destination               = "0.0.0.0/0"
#   destination_type          = "CIDR_BLOCK"
# }

# Ingress Rule: Kubelet API (Port 10250)
resource "oci_core_network_security_group_security_rule" "allow_kubelet" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = oci_core_subnet.oke_subnet.cidr_block
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 10250
      max = 10250
    }
  }
}

# Ingress Rule: ICMP Type 3, Code 4 (Destination Unreachable / Fragmentation Needed)
resource "oci_core_network_security_group_security_rule" "allow_icmp_fragmentation" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                 = "INGRESS"
  protocol                  = "1" # ICMP
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"

  icmp_options {
    type = 3
    code = 4
  }
}

# Ingress Rule: Instance Metadata Service (IMDS) and Oracle Services
resource "oci_core_network_security_group_security_rule" "allow_oracle_services" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source                    = "169.254.169.254/32"
  source_type               = "CIDR_BLOCK"
}

# Ingress Rule: Specific Subnet Access (10.0.16.0/20) for all TCP
resource "oci_core_network_security_group_security_rule" "allow_tcp_from_subnet" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = "10.0.16.0/20"
  source_type               = "CIDR_BLOCK"

  # Note: Leaving tcp_options out allows ALL ports for the protocol
}
# 1. Egress: Allow All Traffic (General Outbound)
resource "oci_core_network_security_group_security_rule" "egress_allow_all" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}

# 2. Egress: ICMP Type 3, Code 4 (Path MTU Discovery)
resource "oci_core_network_security_group_security_rule" "egress_icmp_fragmentation" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                 = "EGRESS"
  protocol                  = "1" # ICMP
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"

  icmp_options {
    type = 3
    code = 4
  }
}

# 3. Egress: Kubernetes API Server (Port 6443)
resource "oci_core_network_security_group_security_rule" "egress_kube_api" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                 = "EGRESS"
  protocol                  = "6" # TCP
  destination               = oci_core_subnet.oke_subnet.cidr_block
  destination_type          = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 6443
      max = 6443
    }
  }
}

# 4. Egress: Kubelet/Additional K8s Port (Port 12250)
resource "oci_core_network_security_group_security_rule" "egress_kube_12250" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                 = "EGRESS"
  protocol                  = "6" # TCP
  destination               = oci_core_subnet.oke_subnet.cidr_block
  destination_type          = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 12250
      max = 12250
    }
  }
}

# 5. Egress: Oracle Services Network (OSN)
# Note: This uses a Service Id instead of a CIDR block
resource "oci_core_network_security_group_security_rule" "egress_osn_services" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                 = "EGRESS"
  protocol                  = "6" # TCP
  destination               = data.oci_core_services.osn.services[0].cidr_block
  destination_type          = "SERVICE_CIDR_BLOCK"
}




#oke

resource "oci_core_network_security_group" "oke_nsg" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "oke-nsg"
}
# Rule 1: Allow Kubernetes API traffic (VCN CIDR)
resource "oci_core_network_security_group_security_rule" "ingress_k8s_api_vcn" {
  network_security_group_id = oci_core_network_security_group.oke_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = var.vcn_cidr
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 6443
      max = 6443
    }
  }
}

# Rule 2: Allow Kubernetes API traffic (Subnet CIDR calculation)
resource "oci_core_network_security_group_security_rule" "ingress_k8s_api_subnet" {
  network_security_group_id = oci_core_network_security_group.oke_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = oci_core_subnet.oke_subnet.cidr_block
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 6443
      max = 6443
    }
  }
}
resource "oci_core_network_security_group_security_rule" "ingress_k8s_api_subnet2" {
  network_security_group_id = oci_core_network_security_group.oke_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = oci_core_subnet.application_subnet.cidr_block
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 12250
      max = 12250
    }
  }
}

# Rule 3: Allow intra-VCN traffic
resource "oci_core_network_security_group_security_rule" "ingress_intra_vcn" {
  network_security_group_id = oci_core_network_security_group.oke_nsg.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source                    = oci_core_vcn.vcn.cidr_block
  source_type               = "CIDR_BLOCK"
}
resource "oci_core_network_security_group_security_rule" "ingress_icmp_mtu" {
  network_security_group_id = oci_core_network_security_group.oke_nsg.id
  direction                 = "INGRESS"
  protocol                  = "1" # ICMP
  source                    = oci_core_subnet.application_subnet.cidr_block
  source_type               = "CIDR_BLOCK"

  icmp_options {
    type = 3
    code = 4
  }
}
# resource "oci_core_network_security_group_security_rule" "ingress_intra_nsg" {
#   network_security_group_id = oci_core_network_security_group.oke_nsg.id
#   direction                 = "INGRESS"
#   protocol                  = "all"
#   source                    = oci_core_network_security_group.oke_nsg.id
#   source_type               = "NETWORK_SECURITY_GROUP"
# }
# resource "oci_core_network_security_group_security_rule" "ingress_ssh" {
#   network_security_group_id = oci_core_network_security_group.oke_nsg.id
#   direction                 = "INGRESS"
#   protocol                  = "6" # TCP
#   source                    = var.admin_cidr_block # Example: "10.0.0.0/24"
#   source_type               = "CIDR_BLOCK"

#   tcp_options {
#     destination_port_range {
#       min = 22
#       max = 22
#     }
#   }
# }
# Rule 4: Egress - Allow all
resource "oci_core_network_security_group_security_rule" "egress_all" {
  network_security_group_id = oci_core_network_security_group.oke_nsg.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}
# Rule: Egress to Oracle Services Network (TCP All)
resource "oci_core_network_security_group_security_rule" "egress_osn_tcp" {
  network_security_group_id = oci_core_network_security_group.oke_nsg.id
  direction                 = "EGRESS"
  protocol                  = "6" # TCP

  # The OSN CIDR block from the data source
  destination = data.oci_core_services.osn.services[0].cidr_block

  # Must be SERVICE_CIDR_BLOCK, not SERVICE_ID
  destination_type = "SERVICE_CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

# Rule: Egress to Oracle Services Network (ICMP 3,4)
resource "oci_core_network_security_group_security_rule" "egress_osn_icmp" {
  network_security_group_id = oci_core_network_security_group.oke_nsg.id
  direction                 = "EGRESS"

  # Ensure protocol is a string
  protocol = "1"

  # The Oracle Services Network label
  destination = data.oci_core_services.osn.services[0].cidr_block

  # MANDATORY for Service Gateway/OSN
  destination_type = "SERVICE_CIDR_BLOCK"

  # Even if allowing all ICMP, adding the block helps the JSON schema validation
  icmp_options {
    type = 3
    code = 4
  }

  description = "Allow ICMP Fragmentation Needed for OSN (Path MTU Discovery)"
}

# Rule: Egress TCP 10250 (Kubelet Port)
resource "oci_core_network_security_group_security_rule" "egress_kubelet_worker" {
  network_security_group_id = oci_core_network_security_group.oke_nsg.id
  direction                 = "EGRESS"
  protocol                  = "6" # TCP
  destination               = oci_core_subnet.application_subnet.cidr_block
  destination_type          = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 10250
      max = 10250
    }
  }
}

# Rule: Egress ICMP Type 3, Code 4 to Worker Subnet
resource "oci_core_network_security_group_security_rule" "egress_icmp_worker" {
  network_security_group_id = oci_core_network_security_group.oke_nsg.id
  direction                 = "EGRESS"
  protocol                  = "1" # ICMP
  destination               = oci_core_subnet.application_subnet.cidr_block
  destination_type          = "CIDR_BLOCK"

  icmp_options {
    type = 3
    code = 4
  }
}

##########file storage nsg######################

resource "oci_core_network_security_group" "fss_nsg" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "fss-nsg"
}

# Allow NFS ports from bastion NSG
resource "oci_core_network_security_group_security_rule" "fss_ingress_nfs1" {
  network_security_group_id = oci_core_network_security_group.fss_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  #source_type               = "NETWORK_SECURITY_GROUP"
  source      = oci_core_subnet.bastion_subnet.cidr_block
  source_type = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = 111
      max = 111
    }
  }
}
resource "oci_core_network_security_group_security_rule" "fss_ingress_nfs_app1" {
  network_security_group_id = oci_core_network_security_group.fss_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  #source_type               = "NETWORK_SECURITY_GROUP"
  source      = oci_core_subnet.application_subnet.cidr_block
  source_type = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = 111
      max = 111
    }
  }
}
# Repeat similar rules for 2048-2049, 2050-2051, 32765-32768
resource "oci_core_network_security_group_security_rule" "fss_ingress_nfs2" {
  network_security_group_id = oci_core_network_security_group.fss_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source_type               = "CIDR_BLOCK"
  source                    = oci_core_subnet.bastion_subnet.cidr_block

  tcp_options {
    destination_port_range {
      min = 2048
      max = 2049
    }
  }
}
resource "oci_core_network_security_group_security_rule" "fss_ingress_nfs_app2" {
  network_security_group_id = oci_core_network_security_group.fss_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source_type               = "CIDR_BLOCK"
  source                    = oci_core_subnet.application_subnet.cidr_block

  tcp_options {
    destination_port_range {
      min = 2048
      max = 2049
    }
  }
}

#2050-2051
resource "oci_core_network_security_group_security_rule" "fss_ingress_nfs3" {
  network_security_group_id = oci_core_network_security_group.fss_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source_type               = "CIDR_BLOCK"
  source                    = oci_core_subnet.bastion_subnet.cidr_block

  tcp_options {
    destination_port_range {
      min = 2050
      max = 2051
    }
  }
}
resource "oci_core_network_security_group_security_rule" "fss_ingress_nfs_app3" {
  network_security_group_id = oci_core_network_security_group.fss_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source_type               = "CIDR_BLOCK"
  source                    = oci_core_subnet.application_subnet.cidr_block

  tcp_options {
    destination_port_range {
      min = 2050
      max = 2051
    }
  }
}
#32765-32768
resource "oci_core_network_security_group_security_rule" "fss_ingress_nfs4" {
  network_security_group_id = oci_core_network_security_group.fss_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source_type               = "CIDR_BLOCK"
  source                    = oci_core_subnet.bastion_subnet.cidr_block

  tcp_options {
    destination_port_range {
      min = 32765
      max = 32768
    }
  }
}
resource "oci_core_network_security_group_security_rule" "fss_ingress_nfs_app4" {
  network_security_group_id = oci_core_network_security_group.fss_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source_type               = "CIDR_BLOCK"
  source                    = oci_core_subnet.application_subnet.cidr_block

  tcp_options {
    destination_port_range {
      min = 32765
      max = 32768
    }
  }
}
#egress
resource "oci_core_network_security_group_security_rule" "allow_all_egress" {
  network_security_group_id = oci_core_network_security_group.fss_nsg.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}
