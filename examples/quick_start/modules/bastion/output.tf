################################################
# Display Output 
################################################
output "public_ip" {
  value = "${oci_core_instance.bastion.public_ip}"
}
