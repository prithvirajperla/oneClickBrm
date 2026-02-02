# Generate SSH key pair
resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

# Save private key locally (optional)
resource "local_file" "bastion_private_key" {
  content  = tls_private_key.bastion_key.private_key_pem
  filename = "./bastion_private_key.pem"

}