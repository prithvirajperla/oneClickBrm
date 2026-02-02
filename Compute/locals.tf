locals {
  # Filter the list of certified OKE images for the specific version string
  # This looks for the image name you provided earlier
  all_sources = data.oci_containerengine_node_pool_option.oke_options.sources

  target_image_ocid = [
    for s in local.all_sources : s.image_id
    if length(regexall("Oracle-Linux-8\\.10-\\d{4}\\.\\d{2}\\.\\d{2}-0-OKE-1\\.33\\.1-.*", s.source_name)) > 0
  ][0]

  encodedpass    = base64encode(var.db_admin_password)
  encodedpinpass = base64encode(var.pinpass)
}


#oc-cn-init-db-helm-chart
#-pindb-init-override-values.yaml
locals {
  initdb_overridefile = templatefile("${path.module}/templates/INITDB-override.yaml.tpl", {
    DBHOST    = "${var.dbhostname}.${var.dbsubnetdomain}"
    DBSERVICE = "${lower(var.pdb_name)}.${var.dbsubnetdomain}"
    DBPASS    = "${local.encodedpass}"
    PINPASS   = "${local.encodedpinpass}"
    DBIP      = "${var.db_private_ip}"
  })
}

#oc-cn-op-job-helm-chart
#-override-values.yaml
locals {
  op_overridefile = templatefile("${path.module}/templates/OP-override-values.yaml.tpl", {
    DBHOST    = "${var.dbhostname}.${var.dbsubnetdomain}"
    DBSERVICE = "${lower(var.pdb_name)}.${var.dbsubnetdomain}"
    DBPASS    = "${local.encodedpass}"
    PINPASS   = "${local.encodedpinpass}"
  })
}
#-pindb-op-job-override-values.yaml
locals {
  op_pinoverridefile = templatefile("${path.module}/templates/OP-pin.yaml.tpl", {
    DBHOST    = "${var.dbhostname}.${var.dbsubnetdomain}"
    DBSERVICE = "${lower(var.pdb_name)}.${var.dbsubnetdomain}"
    DBPASS    = "${local.encodedpass}"
    PINPASS   = "${local.encodedpinpass}"
  })
}

#oc-cn-helm-chart
#-override-values.yaml
locals {
  helm_overridefile = templatefile("${path.module}/templates/HELM-override-values.yaml.tpl", {
    DBHOST    = "${var.dbhostname}.${var.dbsubnetdomain}"
    DBSERVICE = "${lower(var.pdb_name)}.${var.dbsubnetdomain}"
    DBPASS    = "${local.encodedpass}"
    PINPASS   = "${local.encodedpinpass}"
  })
}
#-pindb-brm-override-values.yaml
locals {
  helm_pinoverridefile = templatefile("${path.module}/templates/HELM-pin.yaml.tpl", {
    DBHOST    = "${var.dbhostname}.${var.dbsubnetdomain}"
    DBSERVICE = "${lower(var.pdb_name)}.${var.dbsubnetdomain}"
    DBPASS    = "${local.encodedpass}"
    PINPASS   = "${local.encodedpinpass}"
  })
}

#oc-cn-ece-helm-chart
#-override-values.yaml
locals {
  ece_overridefile = templatefile("${path.module}/templates/ECE-override-values.yaml.tpl", {
    DBHOST    = "${var.dbhostname}.${var.dbsubnetdomain}"
    DBSERVICE = "${lower(var.pdb_name)}.${var.dbsubnetdomain}"
    DBPASS    = "${local.encodedpass}"
    PINPASS   = "${local.encodedpinpass}"
  })
}
#-pindb-ece-override-values.yaml
locals {
  ece_pinoverridefile = templatefile("${path.module}/templates/ECE-pin.yaml.tpl", {
    DBHOST    = "${var.dbhostname}.${var.dbsubnetdomain}"
    DBSERVICE = "${lower(var.pdb_name)}.${var.dbsubnetdomain}"
    DBPASS    = "${local.encodedpass}"
    PINPASS   = "${local.encodedpinpass}"
  })
}