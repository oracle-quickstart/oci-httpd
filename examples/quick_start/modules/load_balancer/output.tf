output "loadbalancer_ip" {
  value = "${oci_load_balancer.lb1.ip_addresses}"
}

output "private_key" {
  value = "${ join(" ", tls_private_key.privkey.*.private_key_pem) }"
}

output "ca_certificate" {
  value = "${ join(" ", tls_self_signed_cert.self_cert.*.cert_pem) }"
}

output "public_certificate" {
  value = "${ join(" ", tls_self_signed_cert.self_cert.*.cert_pem) }"
}
