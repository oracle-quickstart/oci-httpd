output "bastion_subnet" {
  value = "${oci_core_subnet.bastion.id}"
}

output "server1_subnet" {
  value = "${oci_core_subnet.private1.id}"
}

output "server2_subnet" {
  value = "${oci_core_subnet.private2.id}"
}

output "server3_subnet" {
  value = "${oci_core_subnet.private3.id}"
}

output "pri_lb_subnet" {
  value = "${oci_core_subnet.public1.id}"
}

output "sby_lb_subnet" {
  value = "${oci_core_subnet.public2.id}"
}

output "ad1" {
  value = "${oci_core_subnet.private1.availability_domain}"
}

output "ad2" {
  value = "${oci_core_subnet.private2.availability_domain}"
}

output "ad3" {
  value = "${oci_core_subnet.private3.availability_domain}"
}
