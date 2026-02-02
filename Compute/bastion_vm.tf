resource "oci_core_instance" "bastion" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compute_compartment_id
  display_name        = var.bastion_display_name
  shape               = var.bastion_shape

  shape_config {
    ocpus         = 4
    memory_in_gbs = 16
  }

  source_details {
    source_type             = "image"
    source_id               = var.bastion_img_id
    boot_volume_size_in_gbs = 50 # <-- your golden image OCID
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
    #hostname_label   = "bastion"
  }

metadata = {
    ssh_authorized_keys = join("\n", compact([
      trimspace(tls_private_key.bastion_key.public_key_openssh),
      var.custom_rsa_key != null ? trimspace(var.custom_rsa_key) : null,
      try(trimspace(file(var.pub_rsa_key_path)), null)
    ]))
  }
}

