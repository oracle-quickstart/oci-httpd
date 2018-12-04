output "bastion_public_ip" {
    value = "${module.bastion.public_ip}"
}

output "apache_instance1_ip" {
    value = "${module.apache_http_server1.private_ip}"
}

output "apache_instance2_ip" {
    value = "${module.apache_http_server2.private_ip}"
}

output "apache_instance3_ip" {
    value = "${module.apache_http_server3.private_ip}"
}

output "loadbalancer_ip" {
    value = "${module.apache_load_balancer.loadbalancer_ip}"
}
