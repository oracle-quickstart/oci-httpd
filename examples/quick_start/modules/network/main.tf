############################################
# Create VCN
############################################
provider "oci" {
  region           = "${var.region}"
  tenancy_ocid     = "${var.tenancy_ocid}"
  user_ocid        = "${var.user_ocid}"
  fingerprint      = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
}

resource "oci_core_virtual_network" "apache_vcn" {
  cidr_block     = "${var.vcn_cidr}"
  dns_label      = "apvcn"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "apache_vcn"
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}

############################################
# Create NAT gateway
############################################
resource "oci_core_nat_gateway" "apache_nat_gateway" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.apache_vcn.id}"
  display_name   = "apache_nat_gateway"
}

############################################
# Create Internet gateway
############################################
resource "oci_core_internet_gateway" "apache_internet_gateway" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "apache_internet_gateway"
  vcn_id         = "${oci_core_virtual_network.apache_vcn.id}"
}

############################################
# Create subnet, route_table and 
# security_rules for bastion
############################################
resource "oci_core_subnet" "bastion" {
  availability_domain = "${local.ad3}"
  cidr_block          = "${local.bastion_subnet_prefix}"
  display_name        = "bastion"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.apache_vcn.id}"
  route_table_id      = "${oci_core_route_table.bastion.id}"

  security_list_ids = [
    "${oci_core_security_list.bastion.id}",
  ]

  dns_label                  = "bastion"
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_route_table" "bastion" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.apache_vcn.id}"
  display_name   = "bastion"

  route_rules {
    destination       = "${local.anywhere}"
    network_entity_id = "${oci_core_internet_gateway.apache_internet_gateway.id}"
  }
}

resource "oci_core_security_list" "bastion" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "apache_bastion"
  vcn_id         = "${oci_core_virtual_network.apache_vcn.id}"

  ingress_security_rules {
    source   = "${local.anywhere}"
    protocol = "${local.tcp_protocol}"

    tcp_options {
      "min" = 22
      "max" = 22
    }
  }

  egress_security_rules {
    destination = "${var.vcn_cidr}"
    protocol    = "${local.tcp_protocol}"

    tcp_options {
      "min" = 22
      "max" = 22
    }
  }
}

############################################
# Create route_tables
############################################
resource "oci_core_route_table" "private" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.apache_vcn.id}"
  display_name   = "apache_private_route"

  route_rules = [
    {
      destination       = "${local.anywhere}"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = "${oci_core_nat_gateway.apache_nat_gateway.id}"
    },
  ]
}

resource "oci_core_route_table" "public" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.apache_vcn.id}"
  display_name   = "apache_public_route"

  route_rules = [
    {
      destination       = "${local.anywhere}"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = "${oci_core_internet_gateway.apache_internet_gateway.id}"
    },
  ]
}

############################################
# Create security_rules
############################################
resource "oci_core_security_list" "secrule1" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "apache_secrule1"
  vcn_id         = "${oci_core_virtual_network.apache_vcn.id}"

  ingress_security_rules = [{
    tcp_options {
      "min" = 22
      "max" = 22
    }

    source   = "${local.anywhere}"
    protocol = "${local.tcp_protocol}"
  },
    {
      tcp_options {
        "max" = 80
        "min" = 80
      }

      protocol = "${local.tcp_protocol}"
      source   = "${local.anywhere}"
    },
  ]

  egress_security_rules = [{
    destination = "${local.anywhere}"
    protocol    = "${local.all_protocols}"
  },
    {
      tcp_options {
        "max" = 80
        "min" = 80
      }

      protocol    = "${local.tcp_protocol}"
      destination = "${local.anywhere}"
    },
  ]
}

resource "oci_core_security_list" "secrule2" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "apache_secrule2"
  vcn_id         = "${oci_core_virtual_network.apache_vcn.id}"

  /*ingress_security_rules {
    source   = "${local.anywhere}"
    protocol = "${local.tcp_protocol}"

    tcp_options {
      "min" = 80
      "max" = 80
    }
  }*/

  ingress_security_rules = [{
    tcp_options {
      "min" = 22
      "max" = 22
    }

    source   = "${local.anywhere}"
    protocol = "${local.tcp_protocol}"
  },
    {
      tcp_options {
        "max" = 80
        "min" = 80
      }

      protocol = "${local.tcp_protocol}"
      source   = "${local.anywhere}"
    },
  ]
  egress_security_rules {
    destination = "${local.anywhere}"
    protocol    = "${local.all_protocols}"
  }
}

############################################
# Create subnet
############################################
resource "oci_core_subnet" "private1" {
  availability_domain = "${local.ad1}"
  cidr_block          = "${local.private_subnet1_prefix}"
  display_name        = "apache_private1"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.apache_vcn.id}"
  route_table_id      = "${oci_core_route_table.private.id}"

  security_list_ids = [
    "${oci_core_security_list.secrule1.id}",
  ]

  dns_label                  = "private1"
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_subnet" "private2" {
  availability_domain = "${local.ad2}"
  cidr_block          = "${local.private_subnet2_prefix}"
  display_name        = "apache_private2"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.apache_vcn.id}"
  route_table_id      = "${oci_core_route_table.private.id}"

  security_list_ids = [
    "${oci_core_security_list.secrule1.id}",
  ]

  dns_label                  = "private2"
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_subnet" "private3" {
  availability_domain = "${local.ad3}"
  cidr_block          = "${local.private_subnet3_prefix}"
  display_name        = "apache_private3"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.apache_vcn.id}"
  route_table_id      = "${oci_core_route_table.private.id}"

  security_list_ids = [
    "${oci_core_security_list.secrule1.id}",
  ]

  dns_label                  = "private3"
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_subnet" "public1" {
  availability_domain = "${local.ad1}"
  cidr_block          = "${local.public_subnet1_prefix}"
  display_name        = "apache_public1"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.apache_vcn.id}"
  route_table_id      = "${oci_core_route_table.public.id}"

  security_list_ids = [
    "${oci_core_security_list.secrule2.id}",
  ]

  dns_label                  = "public1"
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_subnet" "public2" {
  availability_domain = "${local.ad2}"
  cidr_block          = "${local.public_subnet2_prefix}"
  display_name        = "apache_public2"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.apache_vcn.id}"
  route_table_id      = "${oci_core_route_table.public.id}"

  security_list_ids = [
    "${oci_core_security_list.secrule2.id}",
  ]

  dns_label                  = "public2"
  prohibit_public_ip_on_vnic = false
}
