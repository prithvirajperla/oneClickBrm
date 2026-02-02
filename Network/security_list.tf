
# # 
# resource "oci_core_security_list" "db_sl_private" {
#   compartment_id = var.network_compartment_id
#   vcn_id         = oci_core_vcn.vcn.id
#   display_name   = "db-private-security-list"

#   # 1. Allow SSH from Bastion Subnet (Port 22)
#   ingress_security_rules {
#     protocol = "6" # TCP
#     source   = oci_core_subnet.bastion_subnet.cidr_block #practice: use the specific CIDR variable
#     tcp_options {
#       min = 22
#       max = 22
#     }
#     description = "Allow SSH access from Bastion"
#   }

#   # 2. Allow MySQL from Application/OKE Subnet (Port 3306)
#   ingress_security_rules {
#     protocol = "6" # TCP
#     source   = oci_core_subnet.application_subnet.cidr_block # CIDR where your OKE nodes/Apps live
#     tcp_options {
#       min = 3306
#       max = 3306
#     }
#     description = "Allow MySQL access from OKE/App nodes"
#   }

#   # 3. Allow MySQL from Bastion Subnet (Port 3306)
#   # NEEDED FOR YOUR TUNNEL TO WORK
#   ingress_security_rules {
#     protocol = "6" # TCP
#     source   = oci_core_subnet.bastion_subnet.cidr_block
#     tcp_options {
#       min = 3306
#       max = 3306
#     }
#     description = "Allow MySQL tunnel access from Bastion VM"
#   }

#   # Egress: allow all outbound traffic
#   egress_security_rules {
#     protocol    = "all"
#     destination = "0.0.0.0/0"
#   }
# }

resource "oci_core_security_list" "db_sl_private" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "db-private-security-list"

  # 1. SSH Access (For administrative tasks via Bastion)
  ingress_security_rules {
    protocol = "6"
    source   = oci_core_subnet.bastion_subnet.cidr_block
    tcp_options {
      min = 22
      max = 22
    }
    description = "Allow SSH from Bastion"
  }
  ingress_security_rules {
    protocol = "6"          # TCP
    source   = var.vcn_cidr # Bastion subnet CIDR
    tcp_options {
      min = 1521
      max = 1521
    }
  }


  # 2. Oracle SQL*Net (For the actual Database Connection)
  ingress_security_rules {
    protocol = "6"
    source   = oci_core_subnet.bastion_subnet.cidr_block # Needed for Tunneling
    tcp_options {
      min = 1521
      max = 1521
    }
    description = "Allow Oracle DB access from Bastion tunnel"
  }

  # 3. Oracle SQL*Net (For OKE/Applications)
  ingress_security_rules {
    protocol = "6"
    source   = oci_core_subnet.application_subnet.cidr_block
    tcp_options {
      min = 1521
      max = 1521
    }
    description = "Allow Oracle DB access from OKE Apps"
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_security_list" "app_subnet_sl" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "app-subnet-sl"

  # Allow intra-VCN traffic
  ingress_security_rules {
    protocol = "all"
    source   = var.vcn_cidr
  }

  # Allow NodePort services (default range 30000-32767)
  ingress_security_rules {
    protocol = "6" # TCP
    source   = var.vcn_cidr

    tcp_options {
      min = 30000
      max = 32767
    }
  }
  ingress_security_rules {
    protocol = "6"
    source   = cidrsubnet(var.vcn_cidr, 12, 0)

    tcp_options {
      min = 22
      max = 22
    }
  }


  # # Allow SSH (optional)
  # ingress_security_rules {
  #   protocol = "6"
  #   source   = "0.0.0.0/0"

  #   tcp_options {
  #     min = 22
  #     max = 22
  #   }
  # }

  # Egress: allow all
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}


resource "oci_core_security_list" "oke_subnet_sl" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "oke-subnet-sl"

  # Allow Kubernetes API traffic
  ingress_security_rules {
    protocol = "6" # TCP
    source   = var.vcn_cidr

    tcp_options {
      min = 6443
      max = 6443
    }
  }
  ingress_security_rules {
    protocol = "6" # TCP
    source   = cidrsubnet(var.vcn_cidr, 12, 0)

    tcp_options {
      min = 6443
      max = 6443
    }
  }

  # Allow SSH (optional)
  # ingress_security_rules {
  #   protocol = "6"
  #   source   = "0.0.0.0/0"

  #   tcp_options {
  #     min = 22
  #     max = 22
  #   }
  # }

  # Allow intra-VCN traffic
  ingress_security_rules {
    protocol = "all"
    source   = oci_core_vcn.vcn.cidr_block
  }

  # Egress: allow all
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}