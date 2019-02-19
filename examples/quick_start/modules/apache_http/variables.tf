#########################################################
# Define instance variables
#########################################################
variable "availability_domain" {}
variable "compartment_ocid" {}
variable "display_name" {}
variable "image_id" {}
variable "shape" {}
variable "subnet_id" {}
variable "ssh_public_key_file" {}
variable "ssh_private_key_file" {}
variable "bastion_host" {}
variable "bastion_user" {}
variable "bastion_private_key" {}
variable "scripts" {}
variable "label_prefix" {}
variable "http_port" {}
variable "https_port" {}
variable "enable_https" {}
variable "server_cnname" {}
variable "cn_name" {}
variable "ca_cert" {}
variable "priv_key" {}
variable "create_selfsigned_cert" {}
variable "selfsigned_priv_key" {}
variable "selfsigned_ca_cert" {}
