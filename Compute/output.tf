output "rsa_public_key" {
  value     = tls_private_key.bastion_key.public_key_openssh
  sensitive = true

}

output "bastion_ip" {
  value = oci_core_instance.bastion.public_ip

}