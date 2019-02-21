################################################
# Create instance
################################################
data "template_file" "apache_setup" {
  template = "${file(var.scripts)}"

  vars {
    http_port    = "${var.http_port}"
    https_port   = "${var.https_port}"
    enable_https = "${var.enable_https}"
    cn_name      = "${var.create_selfsigned_cert == "true" ? var.server_cnname : var.cn_name}"
    ca_cert      = "ca_cert.pem"
    priv_key     = "priv_key.pem"
  }
}

/*data "oci_core_subnet" "subnet" {
    subnet_id = "${var.subnet_id}"
}

data "oci_core_instance" "server" {
    instance_id = "${oci_core_instance.private.id}"
}*/

resource "local_file" "ca_cert" {
  content  = "${var.create_selfsigned_cert == "true" ? var.selfsigned_ca_cert : var.ca_cert}"
  filename = "${path.module}/ca_cert.pem"
}

resource "local_file" "priv_key" {
  content  = "${var.create_selfsigned_cert == "true" ? var.selfsigned_priv_key : var.priv_key}"
  filename = "${path.module}/priv_key.pem"
}

resource "local_file" "setup" {
  content  = "${data.template_file.apache_setup.rendered}"
  filename = "${path.module}/setup_mod.sh"
}

resource "oci_core_instance" "private" {
  availability_domain = "${var.availability_domain}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "${var.display_name}${var.label_prefix}"
  shape               = "${var.shape}"

  source_details {
    source_id   = "${var.image_id}"
    source_type = "image"
  }

  create_vnic_details {
    subnet_id        = "${var.subnet_id}"
    assign_public_ip = false
  }

  metadata {
    ssh_authorized_keys = "${file(var.ssh_public_key_file)}"
  }

  timeouts {
    create = "10m"
  }

  connection = {
    type        = "ssh"
    host        = "${self.private_ip}"
    timeout     = "5m"
    user        = "opc"
    private_key = "${file(var.ssh_private_key_file)}"

    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${file(var.bastion_private_key)}"
  }

  provisioner "file" {
    source      = "${local_file.setup.filename}"
    destination = "~/setup.sh"
  }

  provisioner "file" {
    source      = "${local_file.ca_cert.filename}"
    destination = "~/ca_cert.pem"
  }

  provisioner "file" {
    source      = "${local_file.priv_key.filename}"
    destination = "~/priv_key.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/setup.sh",
      "sudo ~/setup.sh ${var.label_prefix}",
    ]
  }
}
