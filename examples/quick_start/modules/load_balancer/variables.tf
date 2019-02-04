#########################################################
# Define load_balancer variables
#########################################################
variable "compartment_ocid" {}
variable "display_name" {}
variable "subnet_ids" {type="list"}
variable "shape" {}
variable "http_port" {}
variable "https_port" {}
variable "enable_https" {}
variable "hostname1" {}
variable "hostname2" {}
variable "hostname3" {}
variable "hostname1_ip" {}
variable "hostname2_ip" {}
variable "hostname3_ip" {}
variable "lb_ca_certificate" {}
variable "lb_private_key" {}
variable "lb_public_certificate" {}
variable "host_address" {}
