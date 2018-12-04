################################################
# Display Output 
################################################
output "bastion_public_ip" {
  value = "${oci_core_instance.bastion.public_ip}"
}

output "apache_instance_ip1" {
  value = "${oci_core_instance.private1.private_ip}"
}

output "apache_instance_ip2" {
  value = "${oci_core_instance.private2.private_ip}"
}

output "apache_instance_ip3" {
  value = "${oci_core_instance.private3.private_ip}"
}

output "public_instancelb_ip1" {
  value = "${oci_core_instance.publiclb1.public_ip}"
}

output "public_instancelb_ip2" {
  value = "${oci_core_instance.publiclb2.public_ip}"
}

output "apache_instance_ssh_command1" {
  value = "ssh -i $PRIVATE_KEY_PATH -o ProxyCommand=\"ssh -i $PRIVATE_KEY_PATH opc@${oci_core_instance.bastion.public_ip} -W %h:%p %r\" opc@${oci_core_instance.private1.private_ip}"
}

output "apache_instance_ssh_command2" {
  value = "ssh -i $PRIVATE_KEY_PATH -o ProxyCommand=\"ssh -i $PRIVATE_KEY_PATH opc@${oci_core_instance.bastion.public_ip} -W %h:%p %r\" opc@${oci_core_instance.private2.private_ip}"
}

output "apache_instance_ssh_command3" {
  value = "ssh -i $PRIVATE_KEY_PATH -o ProxyCommand=\"ssh -i $PRIVATE_KEY_PATH opc@${oci_core_instance.bastion.public_ip} -W %h:%p %r\" opc@${oci_core_instance.private3.private_ip}"
}

output "lb_public_ip" {
  value = "${oci_load_balancer.lb1.ip_addresses}"
}

output "lb_url_check" {
  value = ["Run this thrice to get output from all 3 servers", "http://${oci_load_balancer.lb1.ip_addresses[0]}"]
}
