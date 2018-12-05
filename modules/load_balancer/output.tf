output "loadbalancer_ip" {
  value = "${oci_load_balancer.lb1.ip_addresses}"
}

output "lb_instance1_ip" {
  value = "${oci_core_instance.publiclb1.public_ip}"
}

output "lb_instance2_ip" {
  value = "${oci_core_instance.publiclb2.public_ip}"
}

