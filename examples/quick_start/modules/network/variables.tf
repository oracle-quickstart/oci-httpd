#########################################################
# Define Network variables
#########################################################
variable "vcn_cidr" {
    default = "10.0.0.0/16"
}
variable "subnet_cidr_offset" {
    default = 5
}
variable "region" {}
variable "compartment_ocid" {}
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}

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

