#########################################################
# Define load_balancer variables
#########################################################
variable "compartment_ocid" {}
variable "availability_domain1" {}
variable "availability_domain2" {}
variable "instance1_name" {}
variable "instance2_name" {}
variable "instance1_subnet" {}
variable "instance2_subnet" {}
variable "instance_shape" {}
variable "instance_image_id" {}
variable "display_name" {}
variable "subnet_ids" {type="list"}
variable "shape" {}
variable "http_port" {}
variable "ssh_public_key_file" {}
variable "ssh_private_key_file" {}
variable "hostname1" {}
variable "hostname2" {}
variable "hostname3" {}
variable "hostname1_ip" {}
variable "hostname2_ip" {}
variable "hostname3_ip" {}
variable "user_data" {}
