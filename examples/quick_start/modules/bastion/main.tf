################################################
# Create bastion instance in given ad
################################################
resource "oci_core_instance" "bastion" {
  availability_domain = "${var.availability_domain}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "${var.display_name}"
  shape               = "${var.shape}"

  source_details {
    source_id   = "${var.image_id}"
    source_type = "image"
  }

  create_vnic_details {
    subnet_id = "${var.subnet_id}"
  }

  metadata {
    ssh_authorized_keys = "${file(var.ssh_public_key_file)}"
  }

  timeouts {
    create = "10m"
  }
}
