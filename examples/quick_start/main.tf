################################################
# Create instances (bastion, public & private)
################################################
resource "oci_core_instance" "bastion" {
  availability_domain = "${local.ad3}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "apache-bastion"
  shape               = "${var.instance_shape}"

  source_details {
    source_id   = "${var.instance_image_id[var.region]}"
    source_type = "image"
  }

  create_vnic_details {
    subnet_id = "${oci_core_subnet.bastion.id}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }

  timeouts {
    create = "10m"
  }
}

resource "oci_core_instance" "publiclb1" {
  availability_domain = "${local.ad1}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "apache-public-lb1"
  shape               = "${var.instance_shape}"

  source_details {
    source_id   = "${var.instance_image_id[var.region]}"
    source_type = "image"
  }

  create_vnic_details {
    subnet_id = "${oci_core_subnet.public1.id}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(var.user-data)}"
  }

  timeouts {
    create = "10m"
  }
}

resource "oci_core_instance" "publiclb2" {
  availability_domain = "${local.ad2}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "apache-public-lb2"
  shape               = "${var.instance_shape}"

  source_details {
    source_id   = "${var.instance_image_id[var.region]}"
    source_type = "image"
  }

  create_vnic_details {
    subnet_id = "${oci_core_subnet.public2.id}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(var.user-data)}"
  }

  timeouts {
    create = "10m"
  }
}

resource "oci_core_instance" "private1" {
  availability_domain = "${local.ad1}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "apache_instance1"
  shape               = "${var.instance_shape}"

  source_details {
    source_id   = "${var.instance_image_id[var.region]}"
    source_type = "image"
  }

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.private1.id}"
    assign_public_ip = false
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
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

      bastion_host        = "${oci_core_instance.bastion.public_ip}"
      bastion_user        = "opc"
      bastion_private_key = "${file(var.ssh_private_key_file)}"
  }

  provisioner "remote-exec" {
    inline = [
        "echo 'This instance is for apache installation'",
        "sudo service httpd status",
        "sudo yum -y install httpd",
        "sudo service httpd start",
        "sudo service httpd enable",
        "sudo service httpd status",
        "sudo firewall-cmd --zone=public --permanent --add-port=80/tcp",
        "sudo firewall-cmd --reload",
        "sudo sh -c 'echo \"Hello world 1\" > /var/www/html/index.html'",
        "echo 'check done'",
    ]
  }
}

resource "oci_core_instance" "private2" {
  availability_domain = "${local.ad2}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "apache_instance2"
  shape               = "${var.instance_shape}"

  source_details {
    source_id   = "${var.instance_image_id[var.region]}"
    source_type = "image"
  }

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.private2.id}"
    assign_public_ip = false
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
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

      bastion_host        = "${oci_core_instance.bastion.public_ip}"
      bastion_user        = "opc"
      bastion_private_key = "${file(var.ssh_private_key_file)}"
  }

  provisioner "remote-exec" {
    inline = [
        "echo 'This instance is for apache installation'",
        "sudo service httpd status",
        "sudo yum -y install httpd",
        "sudo service httpd start",
        "sudo service httpd enable",
        "sudo service httpd status",
        "sudo firewall-cmd --zone=public --permanent --add-port=80/tcp",
        "sudo firewall-cmd --reload",
        "sudo sh -c 'echo \"Hello world 2\" > /var/www/html/index.html'",
        "echo 'check done'",
    ]
  }
}

resource "oci_core_instance" "private3" {
  availability_domain = "${local.ad3}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "apache_instance3"
  shape               = "${var.instance_shape}"

  source_details {
    source_id   = "${var.instance_image_id[var.region]}"
    source_type = "image"
  }

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.private3.id}"
    assign_public_ip = false
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
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

      bastion_host        = "${oci_core_instance.bastion.public_ip}"
      bastion_user        = "opc"
      bastion_private_key = "${file(var.ssh_private_key_file)}"
  }

  provisioner "remote-exec" {
    inline = [
        "echo 'This instance is for apache installation'",
        "sudo service httpd status",
        "sudo yum -y install httpd",
        "sudo service httpd start",
        "sudo service httpd enable",
        "sudo service httpd status",
        "sudo firewall-cmd --zone=public --permanent --add-port=80/tcp",
        "sudo firewall-cmd --reload",
        "sudo sh -c 'echo \"Hello world 3\" > /var/www/html/index.html'",
        "echo 'check done'",
    ]
  }
}

