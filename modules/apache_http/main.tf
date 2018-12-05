################################################
# Create instance
################################################
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
      source        = "./modules/apache_http/scripts/setup.sh"
      destination   = "~/setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x ~/setup.sh",
        "sudo ~/setup.sh ${var.label_prefix}",
    ]
  }
}

