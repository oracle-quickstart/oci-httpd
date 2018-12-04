###############################################
# Create Load Balancer
###############################################
/* Load Balancer */
resource "oci_load_balancer" "lb1" {
  shape          = "100Mbps"
  compartment_id = "${var.compartment_ocid}"
  subnet_ids     = [
    "${oci_core_subnet.public1.id}",
    "${oci_core_subnet.public2.id}",
  ]
  display_name   = "apache_lb1"
}

resource "oci_load_balancer_backend_set" "lb-bes1" {
  name             = "lb-bes1"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  policy           = "ROUND_ROBIN"
  health_checker {
    port     = "80"
    protocol = "HTTP"
    response_body_regex= ".*"
    url_path= "/"
  }
}

resource "oci_load_balancer_hostname" "test_hostname1" {
  hostname         = "app.example.com"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  name             = "hostname1"
}

resource "oci_load_balancer_hostname" "test_hostname2" {
  hostname         = "app2.example.com"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  name             = "hostname2"
}

resource "oci_load_balancer_hostname" "test_hostname3" {
  hostname         = "app3.example.com"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  name             = "hostname3"
}

resource "oci_load_balancer_listener" "lb-listener1" {
  load_balancer_id         = "${oci_load_balancer.lb1.id}"
  name                     = "http"
  default_backend_set_name = "${oci_load_balancer_backend_set.lb-bes1.name}"
  hostname_names           = ["${oci_load_balancer_hostname.test_hostname1.name}", "${oci_load_balancer_hostname.test_hostname2.name}", "${oci_load_balancer_hostname.test_hostname3.name}"]
  port                     = 80
  protocol                 = "HTTP"

  connection_configuration {
    idle_timeout_in_seconds = "2"
  }
}

resource "oci_load_balancer_backend" "lb-be1" {
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes1.name}"
  ip_address       = "${oci_core_instance.private1.private_ip}"
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_backend" "lb-be2" {
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes1.name}"
  ip_address       = "${oci_core_instance.private2.private_ip}"
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_backend" "lb-be3" {
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes1.name}"
  ip_address       = "${oci_core_instance.private3.private_ip}"
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}
