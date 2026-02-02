##########=====BASTION CONFIG=====##########

#-OCI-CONFIG
#This resource is responsible for loading OCI configuration data into the bastion host at the .oci/config location.
resource "null_resource" "copy_oci_config" {
  depends_on = [oci_core_instance.bastion]

  connection {
    type        = "ssh"
    host        = oci_core_instance.bastion.public_ip
    user        = "opc"
    private_key = tls_private_key.bastion_key.private_key_pem
  }
  lifecycle {
    replace_triggered_by = [oci_core_instance.bastion]
  }

  #This provisioner copies the OCI tenancy API key to the bastion host.
  provisioner "file" {
    source      = var.api_key_path
    destination = "/home/opc/.oci/key.pem"


  }
  #The provisioner will dynamically load the OCI configuration details, using variables, into the bastion host at the .oci/config path.
  provisioner "file" {
    content     = <<EOT
[DEFAULT]
user=${var.user_ocid}
fingerprint=${var.fingerprint}
tenancy=${var.tenancy_ocid}
region=${var.region}
key_file= /home/opc/.oci/key.pem
EOT
    destination = "/home/opc/.oci/config"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/opc/.oci/key.pem", # Only owner can read/write
      "chmod 600 /home/opc/.oci/config"
    ]
  }

}


#-OKE-CONFIG
#This resource configures the kubecontext and grants access to the OKE cluster.
resource "null_resource" "copy_kubeconfig" {
  depends_on = [oci_core_instance.bastion, oci_containerengine_node_pool.node_pool]
  lifecycle {
    replace_triggered_by = [oci_core_instance.bastion, oci_containerengine_cluster.cluster]
  }

  connection {
    type        = "ssh"
    host        = oci_core_instance.bastion.public_ip
    user        = "opc"
    private_key = tls_private_key.bastion_key.private_key_pem
  }
  provisioner "file" {
    content     = data.oci_containerengine_cluster_kube_config.oke_kubeconfig.content
    destination = "/home/opc/.kube/config"


  }
  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/opc/.kube/config",
      "pip install oci-cli --upgrade"
    ]
  }



}


#-DATABASE-KEY-UPLOAD-TO-BASTION(db_key)
resource "null_resource" "copy_db_key_config" {
  depends_on = [oci_core_instance.bastion, tls_private_key.bastion_key]
  lifecycle {
    replace_triggered_by = [oci_core_instance.bastion, tls_private_key.bastion_key]
  }
  connection {
    type        = "ssh"
    host        = oci_core_instance.bastion.public_ip
    user        = "opc"
    private_key = tls_private_key.bastion_key.private_key_pem
  }

  provisioner "file" {
    content     = tls_private_key.bastion_key.private_key_pem
    destination = "/home/opc/db_key"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/opc/db_key"
    ]
  }
}

#-DATABASE-CONFIG

resource "null_resource" "copy_sql_script_config" {
  depends_on = [oci_core_instance.bastion]
  lifecycle {
    replace_triggered_by = []
  }
  connection {
    type        = "ssh"
    host        = oci_core_instance.bastion.public_ip
    user        = "opc"
    private_key = tls_private_key.bastion_key.private_key_pem
  }
  #--COPY-SQL-COMMANDS-TO-BASTION
  provisioner "file" {
    source      = "${path.module}/setup.sql"
    destination = "/home/opc/setup.sql"
  }
  #--EXECUTE-SQL-COMMANDS-IN-PDB
  provisioner "remote-exec" {
    inline = [
      "sqlplus sys/${var.db_admin_password}@//${var.db_private_ip}:1521/${lower(var.pdb_name)}.${var.dbsubnetdomain} as sysdba @/home/opc/setup.sql"
    ]
  }


}


#-HELM-CONFIG

resource "null_resource" "uploads_tar_gz" {
  depends_on = [oci_core_instance.bastion] #null_resource.mycharts_dir]
  lifecycle {
    replace_triggered_by = [oci_core_instance.bastion]
  }
  connection {
    type        = "ssh"
    host        = oci_core_instance.bastion.public_ip
    user        = "opc"
    private_key = tls_private_key.bastion_key.private_key_pem
  }
  #--MAKE-DIR-FOR-HELM-CHARTS
  provisioner "remote-exec" {
    inline = [
      # 1. Create the directory
      "mkdir -p /home/opc/mycharts",
      # 2. Make the path permanent by adding it to .bashrc
      # We use 'grep' to make sure we don't add it multiple times if the script reruns
      "grep -q 'HELM_CHART_PATH' ~/.bashrc || echo 'export HELM_CHART_PATH=/home/opc/mycharts' >> ~/.bashrc",
      # 3. Source it for the current session (if you have more commands following this)
      "export HELM_CHART_PATH=/home/opc/mycharts"
    ]
  }
  #--UPLOAD-HELM-CHARTS-TO-BAISTON
  provisioner "file" {
    source      = "${path.module}/helm.tar.gz"
    destination = "/home/opc/mycharts/helm.tar.gz"


  }
  #--UNZIP-HELM-CHARTS
  provisioner "remote-exec" {
    inline = [
      # 1. Navigate to the directory
      "cd /home/opc/mycharts",

      # 2. Extract the tar.gz file
      # -x: extract, -z: gzip, -v: verbose, -f: file
      "tar -xzvf helm.tar.gz",

      # 3. Optional: Remove the tarball after extraction to save space
      "rm helm.tar.gz"
    ]
  }
}


#--CREATE-NAMESPACE-IN-OKE-CLUSTER
resource "null_resource" "create_namespace" {
  depends_on = [null_resource.copy_kubeconfig, oci_containerengine_node_pool.node_pool]
  lifecycle {
    replace_triggered_by = [oci_containerengine_cluster.cluster]
  }
  provisioner "remote-exec" {
    inline = [
      # "kubectl create namespace initdb",
      "kubectl create namespace weblogic-operator",
      "kubectl create namespace brm15-apps",
      "kubectl create ns wko-operator",
      "kubectl create ns pindb",
      "kubectl create ns brm15-pindb",
      "echo 'alias k=kubectl' >> ~/.bashrc",
      "source ~/.bashrc"

    ]

    connection {
      type        = "ssh"
      host        = oci_core_instance.bastion.public_ip
      user        = "opc"
      private_key = tls_private_key.bastion_key.private_key_pem
    }
  }
}


#--CREATE-SECRETS-IN-OKE-CLUSTER
resource "null_resource" "create_secret" {
  depends_on = [null_resource.create_namespace]
  lifecycle {
    replace_triggered_by = [oci_containerengine_cluster.cluster]
  }
  provisioner "remote-exec" {
    inline = [
      #priv-reg-secret
      "kubectl create secret docker-registry brm-registry --docker-server=${var.dockerServer} --docker-username=${var.dockerUsername} --docker-password=${var.dockerPass} --docker-email=${var.dockeremail} --namespace brm15-pindb",
      #brm-registry-wko-operator
      "kubectl create secret docker-registry brm-registry --docker-server=${var.dockerServer} --docker-username=${var.dockerUsername} --docker-password=${var.dockerPass} --docker-email=${var.dockeremail} --namespace wko-operator",
      #brm-registry-pindb
      "kubectl create secret docker-registry brm-registry --docker-server=${var.dockerServer} --docker-username=${var.dockerUsername} --docker-password=${var.dockerPass} --docker-email=${var.dockeremail} --namespace pindb"
    ]

    connection {
      type        = "ssh"
      host        = oci_core_instance.bastion.public_ip
      user        = "opc"
      private_key = tls_private_key.bastion_key.private_key_pem
    }
  }
}

#--INITDB-CONFIG
resource "null_resource" "init_db_config" {
  depends_on = [null_resource.uploads_tar_gz, null_resource.create_namespace, null_resource.create_secret, null_resource.copy_sql_script_config] #,null_resource.unzip_helm_chart]

  lifecycle {
    replace_triggered_by = [oci_containerengine_cluster.cluster, oci_containerengine_node_pool.node_pool]
  }
  connection {
    type        = "ssh"
    host        = oci_core_instance.bastion.public_ip
    user        = "opc"
    private_key = tls_private_key.bastion_key.private_key_pem
  }
  #---MODIFY-VALUES-IN-OVERIDEFILES
  # provisioner "remote-exec" {
  #   inline = [
  #     #initdb
  #     #"sed -i 's|name: \"brm-registry\"|name: \"priv-reg-secret\"|' /home/opc/mycharts/helm-files/oc-cn-init-db-helm-chart/pindb-init-override-values.yaml",
  #     "sed -i 's|#host: 10.4.89.223|host: ${var.db_private_ip}|' /home/opc/mycharts/helm-files/oc-cn-init-db-helm-chart/pindb-init-override-values.yaml",
  #     "sed -i 's|#port: 1521|port: 1521|' /home/opc/mycharts/helm-files/oc-cn-init-db-helm-chart/pindb-init-override-values.yaml",
  #     "sed -i 's|#password: \"REJhZG1pbl8xMjMj\"|password: \"${local.encodedpass}\"|' /home/opc/mycharts/helm-files/oc-cn-init-db-helm-chart/pindb-init-override-values.yaml",
  #     "sed -i 's|host: \"brmdb.dbsubnet.brmdevvcn.oraclevcn.com\"|host: \"${var.dbhostname}.${var.dbsubnetdomain}\"|' /home/opc/mycharts/helm-files/oc-cn-init-db-helm-chart/pindb-init-override-values.yaml",
  #     "sed -i 's|service: \"brmpdb.dbsubnet.brmdevvcn.oraclevcn.com\"|service: \"${lower(var.pdb_name)}.${var.dbsubnetdomain}\"|' /home/opc/mycharts/helm-files/oc-cn-init-db-helm-chart/pindb-init-override-values.yaml",
  #     "sed -i 's|schemapass: \"Q1RTdHJhaW5lcl8xMjMj\"|schemapass: \"${local.encodedpinpass}\"|' /home/opc/mycharts/helm-files/oc-cn-init-db-helm-chart/pindb-init-override-values.yaml",
  #     "sed -i 's|pipelineschemapass: \"Q1RTdHJhaW5lcl8xMjMj\"|pipelineschemapass: \"${local.encodedpinpass}\"|' /home/opc/mycharts/helm-files/oc-cn-init-db-helm-chart/pindb-init-override-values.yaml"
  #   ]
  # }
  provisioner "file" {
    content     = local.initdb_overridefile
    destination = "/home/opc/mycharts/helm-files/oc-cn-init-db-helm-chart/pindb-init-override-values.yaml"
  }
  #---INSTALL-INITDB-HELM-CHART
  provisioner "remote-exec" {
    inline = [
      "cd /home/opc/mycharts/helm-files/oc-cn-init-db-helm-chart",
      # "helm install brm15-initdb ../oc-cn-init-db-helm-chart -n initdb --values ../oc-cn-init-db-helm-chart/pindb-init-override-values.yaml"  
      "bash helm_install.sh",
      "kubectl wait -n brm15-pindb --for=condition=complete job --all --timeout=35m || echo 'InitDb time exceded'"
    ]
  }
}



#--WEBLOGIC-CONFIG
resource "null_resource" "install-welogic" {
  depends_on = [null_resource.create_namespace, null_resource.init_db_config] #, null_resource.helm-install-initdb1]
  lifecycle {
    replace_triggered_by = [oci_containerengine_cluster.cluster, oci_containerengine_node_pool.node_pool]
  }
  provisioner "remote-exec" {
    inline = [
      "helm repo add weblogic-operator https://oracle.github.io/weblogic-kubernetes-operator/charts",
      "helm repo update",
      "helm install weblogic-operator weblogic-operator/weblogic-operator --namespace weblogic-operator --set domainNamespaceSelectionStrategy=List --set domainNamespaces={pindb}  --wait --version 4.3.0"

    ]

    connection {
      type        = "ssh"
      host        = oci_core_instance.bastion.public_ip
      user        = "opc"
      private_key = tls_private_key.bastion_key.private_key_pem
    }
  }
}

#--WKO-OPERATOR-CONFIG
resource "null_resource" "wko_operator_config" {
  depends_on = [null_resource.create_namespace, null_resource.install-welogic, null_resource.uploads_tar_gz] #null_resource.helm-install-initdb1]
  lifecycle {
    replace_triggered_by = [oci_containerengine_node_pool.node_pool, oci_containerengine_cluster.cluster]
  }
  connection {
    type        = "ssh"
    host        = oci_core_instance.bastion.public_ip
    user        = "opc"
    private_key = tls_private_key.bastion_key.private_key_pem
  }
  #---PODMAN-LOGIN-PULL-IMAGE
  # provisioner "remote-exec" {
  #   inline = [
  #     #"podman login ${var.dockerServer} -u ${var.dockerUsername} -p '${var.dockerPass}'",
  #     "podman login fra.ocir.io -u fry4fxlvxkjt/Default/sourav.bhadra@cognizant.com -p '}Schz}4bt]6Oa#aAA7LE'",
  #     "podman pull fra.ocir.io/fry4fxlvxkjt/communications_monetization/weblogic-kubernetes-operator:4.3.0"
  #   ]
  # }

  #---LABEL-NAMESPACE-IN-OKE-CLUSTER
  provisioner "remote-exec" {
    inline = [
      "kubectl label ns pindb weblogic-operator=enabled"
    ]
  }
  #---MODIFY-OVERIDEFILE-IN-WKO-OPERATOR
  # provisioner "remote-exec" {
  #   inline = [
  #     "sed -i 's/^nodeSelector:/#nodeSelector/; s/^  env: cts/#env: cts/' /home/opc/mycharts/helm-files/weblogic/weblogic-operator/override-values.yaml"
  #   ]
  # }
  #---EXECUTE-WKO-OPERATOR-HELM-CHART
  provisioner "remote-exec" {
    inline = [
      "cd /home/opc/mycharts/helm-files/weblogic/weblogic-operator/",
      "bash helm_install.sh"
    ]
  }
}


#--OC-CN-OP-JOB-CONFIG
resource "null_resource" "op_job_congig" {

  depends_on = [null_resource.wko_operator_config]
  lifecycle {
    replace_triggered_by = [oci_containerengine_cluster.cluster, oci_containerengine_node_pool.node_pool]
  }
  connection {
    type        = "ssh"
    host        = oci_core_instance.bastion.public_ip
    user        = "opc"
    private_key = tls_private_key.bastion_key.private_key_pem
  }
  #---CSIDRIVER-CONFIG
  provisioner "remote-exec" {
    inline = [
      "kubectl get csidriver fss.csi.oraclecloud.com -o yaml > cuscsi.yaml",
      "sed -i 's/fsGroupPolicy: ReadWriteOnceWithFSType/fsGroupPolicy: File/' cuscsi.yaml",
      "kubectl delete -f cuscsi.yaml",
      "kubectl apply -f cuscsi.yaml"
    ]
  }
  #---UPLOAD-STORAGECLASS-CONFIG-IN-BASTION
  provisioner "file" {
    content     = <<-EOT
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: brm-shared-storage
provisioner: fss.csi.oraclecloud.com
parameters:
  availabilityDomain: ${var.mnt_avd}
  mountTargetOcid: ${var.mnt_id}
  compartmentOcid: ${var.mnt_compartment}
  exportOptions: "[{\"source\":\"${var.app_cidr}\",\"requirePrivilegedSourcePort\":false,\"access\":\"READ_WRITE\",\"identitySquash\":\"NONE\"}]"
    EOT
    destination = "/home/opc/storage_class.yaml"
  }
  #---RUN-KUBECTL-CMD-TO-CREATE-STORAGECLASS-IN-OKE-CLUSTER
  provisioner "remote-exec" {
    inline = [
      "kubectl apply -f storage_class.yaml",
      "rm storage_class.yaml"
    ]


  }

  # provisioner "remote-exec" {
  #   inline = [

  #     "sed -i.bak -E 's|brmdbdev1\\.dbsubnet\\.devtestvcn\\.oraclevcn\\.com|dbvm1.dbsubnet.brmvcn.oraclevcn.com|g' /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/override-values.yaml",
  #     "sed -i.bak -E 's|brmchkpdb\\.dbsubnet\\.devtestvcn\\.oraclevcn\\.com|brmpdb.dbsubnet.brmvcn.oraclevcn.com|g'  /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/override-values.yaml",
  #     "sed -i.bak -E 's|password: REJhZG1pbl8xMjMj|password: ${local.encodedpass}|g'  /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/override-values.yaml",
  #     "sed -i.bak -E 's|dbPassword: REJhZG1pbl8xMjMj|dbpassword: ${local.encodedpass}|g'  /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/override-values.yaml",
  #     "sed -i.bak -E 's|pdcSchemaPassword: REJhZG1pbl8xMjMj|pdcSchemaPassword: ${local.encodedpinpass}|g'  /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/override-values.yaml",
  #     "sed -i.bak -E 's|crossRefSchemaPassword: REJhZG1pbl8xMjMj|crossRefSchemaPassword: ${local.encodedpinpass}|g'  /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/override-values.yaml",
  #     "sed -i -e 's/^ *nodeSelector:/#nodeSelector:/' -e 's/^ *env: *cts/#env: cts/' /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/override-values.yaml"
  #   ]
  # }
  provisioner "file" {
    content     = local.op_overridefile
    destination = "/home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/override-values.yaml"
  }
  # provisioner "remote-exec" {
  #   inline = [
  #     "sed -i.bak -E 's|brmdb\\.dbsubnet\\.brmdevvcn\\.oraclevcn\\.com|dbvm1.dbsubnet.brmvcn.oraclevcn.com|g'  /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/pindb-op-job-override-values.yaml",
  #     "sed -i.bak -E 's|brmpdb\\.dbsubnet\\.brmdevvcn\\.oraclevcn\\.com|brmpdb.dbsubnet.brmvcn.oraclevcn.com|g'  /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/pindb-op-job-override-values.yaml",
  #     "sed -i.bak -E 's|schemapass: \\\"Q1RTdHJhaW5lcl8xMjMj\\\"|schemapass: \\\"${local.encodedpinpass}\\\"|g'  /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/pindb-op-job-override-values.yaml",
  #     "sed -i.bak -E 's|password: *\\\"REJhZG1pbl8xMjMj\\\"|password: \\\"${local.encodedpass}\\\"|g'  /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/pindb-op-job-override-values.yaml",
  #     "sed -i.bak -E 's|pipelineschemapass: \\\"Q1RTdHJhaW5lcl8xMjMj\\\"|pipelineschemapass: \\\"${local.encodedpinpass}\\\"|g'  /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/pindb-op-job-override-values.yaml",
  #     "sed -i.bak -E 's|dbPassword: \\\"REJhZG1pbl8xMjMj\\\"|dbpassword: \\\"${local.encodedpass}\\\"|g'  /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/pindb-op-job-override-values.yaml",
  #     "sed -i.bak -E 's|pdcSchemaPassword: \\\"Q1RTdHJhaW5lcl8xMjMj\\\"|pdcSchemaPassword: \\\"${local.encodedpinpass}\\\"|g'  /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/pindb-op-job-override-values.yaml",
  #     "sed -i.bak -E 's|crossRefSchemaPassword: \\\"Q1RTdHJhaW5lcl8xMjMj\\\"|crossRefSchemaPassword: \\\"${local.encodedpinpass}\\\"|g'  /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/pindb-op-job-override-values.yaml",
  #     "sed -i -e 's/^ *nodeSelector:/#nodeSelector:/' -e 's/^ *env: *cts/#env: cts/' /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/pindb-op-job-override-values.yaml"
  #   ]
  # }
  provisioner "file" {
    content     = local.op_pinoverridefile
    destination = "/home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart/pindb-op-job-override-values.yaml"
  }
  provisioner "remote-exec" {
    inline = [
      "cd /home/opc/mycharts/helm-files/oc-cn-op-job-helm-chart",
      "bash helm_install.sh pindb",
      "kubectl wait --for=condition=Ready pods --all -n pindb --timeout=30m || echo 'OP-job time exceded'"
    ]
  }
}



#--OC-CN-HELM-CONFIG
resource "null_resource" "oc-cn-helm-config" {
  depends_on = [null_resource.uploads_tar_gz, null_resource.op_job_congig] #null_resource.unzip_helm_chart]
  lifecycle {
    replace_triggered_by = [oci_containerengine_cluster.cluster, oci_containerengine_node_pool.node_pool]
  }
  connection {
    type        = "ssh"
    host        = oci_core_instance.bastion.public_ip
    user        = "opc"
    private_key = tls_private_key.bastion_key.private_key_pem
  }
  #---UPDATE-VALUES-IN-OVERIDEFILES
  # provisioner "remote-exec" {
  #   inline = [
  #     "sed -i 's|brmdbdev2\\.dbsubnet\\.devtestvcn\\.oraclevcn\\.com|${var.dbhostname}.${var.dbsubnetdomain}|g' /home/opc/mycharts/helm-files/oc-cn-helm-chart/oc-cn-helm-chart/override-values.yaml",
  #     "sed -i 's|brmchkpdb\\.dbsubnet\\.devtestvcn\\.oraclevcn\\.com|${lower(var.pdb_name)}.${var.dbsubnetdomain}|g' /home/opc/mycharts/helm-files/oc-cn-helm-chart/oc-cn-helm-chart/override-values.yaml",
  #     "sed -i 's|password: *REJhZG1pbl8xMjMj|password: ${local.encodedpass}|g' /home/opc/mycharts/helm-files/oc-cn-helm-chart/oc-cn-helm-chart/override-values.yaml",
  #     "sed -i 's|schemapass: *REJhZG1pbl8xMjM|schemapass: ${local.encodedpinpass}|g' /home/opc/mycharts/helm-files/oc-cn-helm-chart/oc-cn-helm-chart/override-values.yaml",
  #     "sed -i -e 's/^ *nodeSelector:$/#nodeSelector:/' -e 's/^ *env: cts/#env: cts/' /home/opc/mycharts/helm-files/oc-cn-helm-chart/oc-cn-helm-chart/override-values.yaml"
  #   ]
  # }
  provisioner "file" {
    content     = local.helm_overridefile
    destination = "/home/opc/mycharts/helm-files/oc-cn-helm-chart/oc-cn-helm-chart/override-values.yaml"
  }
  #---UPDATE-VALUES-IN-PINDB-OVERIDEFILES
  # provisioner "remote-exec" {
  #   inline = [
  #     "sed -i 's|brmdb\\.dbsubnet\\.brmdevvcn\\.oraclevcn\\.com|${var.dbhostname}.${var.dbsubnetdomain}|g' /home/opc/mycharts/helm-files/oc-cn-helm-chart/oc-cn-helm-chart/pindb-brm-override-values.yaml",
  #     "sed -i 's|brmpdb\\.dbsubnet\\.brmdevvcn\\.oraclevcn\\.com|${lower(var.pdb_name)}.${var.dbsubnetdomain}|g' /home/opc/mycharts/helm-files/oc-cn-helm-chart/oc-cn-helm-chart/pindb-brm-override-values.yaml",
  #     "sed -i 's|password: *\\\"REJhZG1pbl8xMjMj\\\"|password: \\\"${local.encodedpass}\\\"|g' /home/opc/mycharts/helm-files/oc-cn-helm-chart/oc-cn-helm-chart/pindb-brm-override-values.yaml",
  #     "sed -i 's|schemapass: *\\\"Q1RTdHJhaW5lcl8xMjMj\\\"|schemapass: \\\"${local.encodedpinpass}\\\"|g' /home/opc/mycharts/helm-files/oc-cn-helm-chart/oc-cn-helm-chart/pindb-brm-override-values.yaml",
  #     "sed -i -e 's/^ *nodeSelector:$/#nodeSelector:/' -e 's/^ *env: cts/#env: cts/' /home/opc/mycharts/helm-files/oc-cn-helm-chart/oc-cn-helm-chart/pindb-brm-override-values.yaml"
  #   ]
  # }
  provisioner "file" {
    content     = local.helm_pinoverridefile
    destination = "/home/opc/mycharts/helm-files/oc-cn-helm-chart/oc-cn-helm-chart/pindb-brm-override-values.yaml"
  }
  provisioner "remote-exec" {
    inline = [
      "cd /home/opc/mycharts/helm-files/oc-cn-helm-chart/oc-cn-helm-chart",
      "bash helm_install.sh pindb",
      "kubectl wait -n pindb --for=condition=complete job --all --timeout=20m || echo 'HELM time exceded'"
    ]
  }


}



resource "null_resource" "oc-cn-ece-config" {
  depends_on = [null_resource.oc-cn-helm-config]
  lifecycle {
    replace_triggered_by = [oci_containerengine_cluster.cluster, oci_containerengine_node_pool.node_pool]
  }
  connection {
    type        = "ssh"
    host        = oci_core_instance.bastion.public_ip
    user        = "opc"
    private_key = tls_private_key.bastion_key.private_key_pem
  }

  provisioner "file" {
    content     = local.ece_overridefile
    destination = "/home/opc/mycharts/helm-files/oc-cn-ece-helm-chart/override-values.yaml"
  }
  provisioner "file" {
    content     = local.ece_pinoverridefile
    destination = "/home/opc/mycharts/helm-files/oc-cn-ece-helm-chart/pindb-ece-override-values.yaml"
  }
  provisioner "remote-exec" {
    inline = ["cd /home/opc/mycharts/helm-files/oc-cn-ece-helm-chart/",
      "bash helm_install.sh pindb"
    ]
  }
}
