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
  count     = "${var.enable_https ? 1 : 0}"
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "self_cert" {
  count           = "${var.enable_https ? 1 : 0}"
  key_algorithm   = "${tls_private_key.privkey.algorithm}"
  private_key_pem = "${tls_private_key.privkey.private_key_pem}"

  validity_period_hours = 26280
  early_renewal_hours   = 8760
  is_ca_certificate     = true
  allowed_uses          = ["cert_signing"]

  subject {
    common_name = "${var.host_address}"
  }
}

resource "oci_load_balancer_certificate" "lb-cert1" {
  count              = "${var.enable_https ? 1 : 0}"
  certificate_name   = "selfsigned_certificate1"
  load_balancer_id   = "${oci_load_balancer.lb1.id}"
  private_key        = "${join("", tls_private_key.privkey.*.private_key_pem)}"
  ca_certificate     = "${join("", tls_self_signed_cert.self_cert.*.cert_pem)}"
  public_certificate = "${join("", tls_self_signed_cert.self_cert.*.cert_pem)}"

  //private_key        = "${var.enable_https ? tls_private_key.privkey.*.private_key_pem : 0}"
  //ca_certificate     = "${var.enable_https ? tls_self_signed_cert.self_cert.*.cert_pem : 0}"
  //public_certificate = "${var.enable_https ? tls_self_signed_cert.self_cert.*.cert_pem : 0}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "oci_load_balancer_listener" "lb-listener2" {
  count                    = "${var.enable_https ? 0 : 1}"
  load_balancer_id         = "${oci_load_balancer.lb1.id}"
  name                     = "http"
  default_backend_set_name = "${oci_load_balancer_backend_set.lb-bes-http.name}"
  hostname_names           = ["${oci_load_balancer_hostname.test_hostname1.name}", "${oci_load_balancer_hostname.test_hostname2.name}", "${oci_load_balancer_hostname.test_hostname3.name}"]
  port                     = "${var.http_port}"
  protocol                 = "HTTP"

  connection_configuration {
    idle_timeout_in_seconds = "2"
  }
}

resource "oci_load_balancer_listener" "lb-listener1" {
  count                    = "${var.enable_https ? 1 : 0}"
  load_balancer_id         = "${oci_load_balancer.lb1.id}"
  name                     = "https"
  default_backend_set_name = "${oci_load_balancer_backend_set.lb-bes-https.name}"
  hostname_names           = ["${oci_load_balancer_hostname.test_hostname1.name}", "${oci_load_balancer_hostname.test_hostname2.name}", "${oci_load_balancer_hostname.test_hostname3.name}"]
  port                     = "${var.https_port}"
  protocol                 = "HTTP"

  connection_configuration {
    idle_timeout_in_seconds = "2"
  }

  ssl_configuration {
    certificate_name        = "${oci_load_balancer_certificate.lb-cert1.certificate_name}"
    verify_peer_certificate = false
  }
}

resource "oci_load_balancer_backend_set" "lb-bes-https" {
  count            = "${var.enable_https ? 1 : 0}"
  name             = "lb-bes-https"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "${var.https_port}"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }

  ssl_configuration {
    certificate_name        = "${oci_load_balancer_certificate.lb-cert1.certificate_name}"
    verify_peer_certificate = false
  }
}

resource "oci_load_balancer_backend_set" "lb-bes-http" {
  count            = "${var.enable_https ? 0 : 1}"
  name             = "lb-bes-http"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "${var.http_port}"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

resource "oci_load_balancer_backend" "lb-be1" {
  count            = "${var.enable_https ? 0 : 1}"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes-http.name}"
  ip_address       = "${var.hostname1_ip}"
  port             = "${var.http_port}"
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_backend" "lb-be2" {
  count            = "${var.enable_https ? 0 : 1}"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes-http.name}"
  ip_address       = "${var.hostname2_ip}"
  port             = "${var.http_port}"
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_backend" "lb-be3" {
  count            = "${var.enable_https ? 0 : 1}"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes-http.name}"
  ip_address       = "${var.hostname3_ip}"
  port             = "${var.http_port}"
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_backend" "https1" {
  count            = "${var.enable_https ? 1 : 0}"
  load_balancer_id = "${oci_load_balancer.lb1.id}"

  //backendset_name  = "${oci_load_balancer_backend_set.lb-bes-https.name}"
  backendset_name = "${var.enable_https ? oci_load_balancer_backend_set.lb-bes-https.name: ""}"
  ip_address      = "${var.hostname1_ip}"
  port            = "${var.https_port}"
  backup          = false
  drain           = false
  offline         = false
  weight          = 1
}

resource "oci_load_balancer_backend" "https2" {
  count            = "${var.enable_https ? 1 : 0}"
  load_balancer_id = "${oci_load_balancer.lb1.id}"

  //backendset_name  = "${oci_load_balancer_backend_set.lb-bes-https.name}"
  backendset_name = "${var.enable_https ? oci_load_balancer_backend_set.lb-bes-https.name: ""}"
  ip_address      = "${var.hostname2_ip}"
  port            = "${var.https_port}"
  backup          = false
  drain           = false
  offline         = false
  weight          = 1
}

resource "oci_load_balancer_backend" "https3" {
  count            = "${var.enable_https ? 1 : 0}"
  load_balancer_id = "${oci_load_balancer.lb1.id}"

  //backendset_name  = "${oci_load_balancer_backend_set.lb-bes-https.name}"
  backendset_name = "${var.enable_https ? oci_load_balancer_backend_set.lb-bes-https.name: ""}"
  ip_address      = "${var.hostname3_ip}"
  port            = "${var.https_port}"
  backup          = false
  drain           = false
  offline         = false
  weight          = 1
}
