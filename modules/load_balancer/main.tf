###############################################
# Create Load Balancer
###############################################
data "template_file" "lb-config" {
  template = "${file(var.user_data)}"

  vars {
    lb_listen_port = "${var.http_port}"
  }
}

resource "oci_core_instance" "publiclb1" {
  availability_domain = "${var.availability_domain1}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "${var.instance1_name}"
  shape               = "${var.instance_shape}"

  source_details {
    source_id   = "${var.instance_image_id}"
    source_type = "image"
  }

  create_vnic_details {
    subnet_id = "${var.instance1_subnet}"
  }

  metadata {
    ssh_authorized_keys = "${file(var.ssh_public_key_file)}"
    user_data = "${base64encode(data.template_file.lb-config.rendered)}"
  }

  timeouts {
    create = "10m"
  }
}

resource "oci_core_instance" "publiclb2" {
  availability_domain = "${var.availability_domain2}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "${var.instance2_name}"
  shape               = "${var.instance_shape}"

  source_details {
    source_id   = "${var.instance_image_id}"
    source_type = "image"
  }

  create_vnic_details {
    subnet_id = "${var.instance2_subnet}"
  }

  metadata {
    ssh_authorized_keys = "${file(var.ssh_public_key_file)}"
    user_data = "${base64encode(data.template_file.lb-config.rendered)}"
  }

  timeouts {
    create = "10m"
  }
}

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

resource "oci_load_balancer_listener" "lb-listener1" {
  load_balancer_id         = "${oci_load_balancer.lb1.id}"
  name                     = "http"
  default_backend_set_name = "${oci_load_balancer_backend_set.lb-bes1.name}"
  hostname_names           = ["${oci_load_balancer_hostname.test_hostname1.name}", "${oci_load_balancer_hostname.test_hostname2.name}", "${oci_load_balancer_hostname.test_hostname3.name}"]
  port                     = "${var.http_port}"
  protocol                 = "HTTP"

  connection_configuration {
    idle_timeout_in_seconds = "2"
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
