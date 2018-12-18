###############################################
# Create Load Balancer
###############################################
/* Load Balancer */
resource "oci_load_balancer" "lb1" {
  shape          = "${var.shape}"
  compartment_id = "${var.compartment_ocid}"
  subnet_ids     = "${var.subnet_ids}"
  display_name   = "${var.display_name}"
}

resource "oci_load_balancer_backend_set" "lb-bes1" {
  name             = "lb-bes1"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  policy           = "ROUND_ROBIN"
  health_checker {
    port     = "${var.http_port}"
    protocol = "HTTP"
    response_body_regex= ".*"
    url_path= "/"
  }
}

resource "oci_load_balancer_hostname" "test_hostname1" {
  hostname         = "${var.hostname1}"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  name             = "hostname1"
}

resource "oci_load_balancer_hostname" "test_hostname2" {
  hostname         = "${var.hostname2}"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  name             = "hostname2"
}

resource "oci_load_balancer_hostname" "test_hostname3" {
  hostname         = "${var.hostname3}"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  name             = "hostname3"
}

resource "tls_private_key" "privkey" {
  //count     = "${var.lb_ca_certificate == "" ? 1 : 0 }"
  count     = 1
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "self_cert" {
  //count           = "${var.lb_ca_certificate == "" ? 1 : 0 }"
  count           = 1
  key_algorithm   = "${tls_private_key.privkey.algorithm}"
  private_key_pem = "${tls_private_key.privkey.private_key_pem}"

  validity_period_hours = 26280
  early_renewal_hours   = 8760
  is_ca_certificate     = true
  allowed_uses          = ["cert_signing"]

  subject {
    common_name  = "${var.host_address}"
    //common_name  = "${oci_load_balancer.lb1.ip_addresses[0]}"
    //organization = "Example, Inc"
  }
}

resource "oci_load_balancer_certificate" "lb-cert1" {
  load_balancer_id   = "${oci_load_balancer.lb1.id}"
  //ca_certificate     = "${var.lb_ca_certificate == "" ? "${tls_self_signed_cert.self_cert.cert_pem}" : file(var.lb_ca_certificate)}"
  certificate_name   = "certificate"
  //private_key        = "${var.lb_private_key == "" ? "${tls_private_key.privkey.private_key_pem}" : file(var.lb_private_key)}"
  //public_certificate = "${var.lb_public_certificate == "" ? "${tls_self_signed_cert.self_cert.cert_pem}" : file(var.lb_public_certificate)}"
  private_key        = "${tls_private_key.privkey.private_key_pem}"
  ca_certificate     = "${tls_self_signed_cert.self_cert.cert_pem}"
  public_certificate = "${tls_self_signed_cert.self_cert.cert_pem}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "oci_load_balancer_listener" "lb-listener1" {
  load_balancer_id         = "${oci_load_balancer.lb1.id}"
  name                     = "${var.enable_https == "true" ? "https" : "http"}"
  default_backend_set_name = "${oci_load_balancer_backend_set.lb-bes1.name}"
  hostname_names           = ["${oci_load_balancer_hostname.test_hostname1.name}", "${oci_load_balancer_hostname.test_hostname2.name}", "${oci_load_balancer_hostname.test_hostname3.name}"]
  port                     = "${var.enable_https == "true" ? var.https_port : var.http_port}"
  protocol                 = "HTTP"

  connection_configuration {
    idle_timeout_in_seconds = "2"
  }

  ssl_configuration {
    certificate_name        = "${oci_load_balancer_certificate.lb-cert1.certificate_name}"
    verify_peer_certificate = false
  }
}

resource "oci_load_balancer_backend" "lb-be1" {
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes1.name}"
  ip_address       = "${var.hostname1_ip}"
  port             = "${var.http_port}"
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_backend" "lb-be2" {
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes1.name}"
  ip_address       = "${var.hostname2_ip}"
  port             = "${var.http_port}"
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_backend" "lb-be3" {
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes1.name}"
  ip_address       = "${var.hostname3_ip}"
  port             = "${var.http_port}"
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}
