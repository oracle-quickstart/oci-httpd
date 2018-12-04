###############################################
# Define required variables
###############################################
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}

variable "ssh_private_key_file" {
  default = "~/.ssh/tf/id_rsa"
}

variable "vcn_cidr" {
  default = "10.0.0.0/16"
}

variable subnet_cidr_offset {
  default = 5
}

variable "instance_image_id" {
  type = "map"

  default = {
    // Oracle-provided image "Oracle-Linux-7.4-2018.02.21-1"
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaaupbfz5f5hdvejulmalhyb6goieolullgkpumorbvxlwkaowglslq"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaajlw3xfie2t5t52uegyhiq2npx7bqyu4uvi2zyu3w3mqayc2bxmaa"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa7d3fsb6272srnftyi4dphdgfjf6gurxqhmv6ileds7ba3m2gltxq"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaaa6h6gj6v4n56mqrbgnosskq63blyv2752g36zerymy63cfkojiiq"
  }
}

variable "instance_shape" {
  default = "VM.Standard1.1"
}

locals {
  bastion_subnet_prefix = "${cidrsubnet(var.vcn_cidr, var.subnet_cidr_offset, 0)}"
  private_subnet1_prefix = "${cidrsubnet(var.vcn_cidr, var.subnet_cidr_offset, 1)}"
  private_subnet2_prefix = "${cidrsubnet(var.vcn_cidr, var.subnet_cidr_offset, 2)}"
  private_subnet3_prefix = "${cidrsubnet(var.vcn_cidr, var.subnet_cidr_offset, 3)}"
  public_subnet1_prefix = "${cidrsubnet(var.vcn_cidr, var.subnet_cidr_offset, 4)}"
  public_subnet2_prefix = "${cidrsubnet(var.vcn_cidr, var.subnet_cidr_offset, 5)}"

  ad1 = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[0],"name")}"
  ad2 = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[1],"name")}"
  ad3 = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[2],"name")}"

  tcp_protocol  = "6"
  all_protocols = "all"
  anywhere      = "0.0.0.0/0"
}

variable "user-data" {
  default = <<EOF
#!/bin/bash -x
echo '################### webserver userdata begins #####################'
touch ~opc/userdata.`date +%s`.start
# echo '########## yum update all ###############'
# yum update -y
echo '########## basic webserver ##############'
yum install -y httpd
systemctl enable  httpd.service
systemctl start  httpd.service
echo '<html><head></head><body><pre><code>' > /var/www/html/index.html
hostname >> /var/www/html/index.html
echo '' >> /var/www/html/index.html
cat /etc/os-release >> /var/www/html/index.html
echo '</code></pre></body></html>' >> /var/www/html/index.html
firewall-offline-cmd --add-service=http
systemctl enable  firewalld
systemctl restart  firewalld
touch ~opc/userdata.`date +%s`.finish
echo '################### webserver userdata ends #######################'
EOF
}
