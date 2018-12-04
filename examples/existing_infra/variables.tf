###############################################
# Required variables
###############################################
variable "region" {
    description = "Region where Compartment OCID resides."
    default = ""
}

variable "compartment_ocid" {
    description = "Compartment OCID when VCN will be created."
    default = ""
}

variable "vcn_cidr" {
    description = "Define CIDR for the vcn"
    default = ""
}

variable "num_http_server" {
    description = "Number of HTTP server to be deployed"
    default = 3
}

variable "bastion_ad" {
    default = ""
}

variable "bastion_subnet_id" {
    description = "Subnet on which bastion will be created"
    default = ""
}

variable "bastion_hostname" {
    description = "Display Name for Bastion"
    default = ""
}

variable "bastion_user" {
    description = "Login user name for Bastion"
    default = "opc"
}

variable "bastion_public_key_file" {
    description = "Public key file for bastion login"
    default = ""
}

variable "bastion_private_key_file" {
    description = "Private key file for bastion login"
    default = ""
}

variable "bastion_image_id" {
  description = "The OCID of an image for bastion to use."
  default = ""
}

variable "bastion_shape" {
    description = "Instance shape to use for bastion instances"
    default = ""
}

variable "ssh_public_key_file" {
  description = "Public SSH keys for the default user on the instance."
  default     = ""
}

variable "ssh_private_key_file" {
  description = "Private SSH keys file path to login into the instance."
  default     = ""
}

variable "instance_ad1" {
  description = "Availability domain for instance1."
  default     = ""
}

variable "instance_ad2" {
  description = "Availability domain for instance2."
  default     = ""
}

variable "instance_ad3" {
  description = "Availability domain for instance3."
  default     = ""
}

variable "instance_image_id" {
  description = "The OCID of an image for slave instance to use."
  default     = ""
}

variable "instance_shape" {
    description = "Instance shape to use for apache instances"
    default = ""
}

variable "instance_subnet1_id" {
    description = "Subnet1 prefix on which instances will be created"
    default = ""
}

variable "instance_subnet2_id" {
    description = "Subnet2 prefix on which instances will be created"
    default = ""
}

variable "instance_subnet3_id" {
    description = "Subnet3 prefix on which instances will be created"
    default = ""
}

variable "instance_name" {
    description = "Name prefix for instances"
    default = ""
}

variable "instance_scripts" {
    description = "Scripts to run on instances"
    default = ""
}

variable "instance_user_data" {
    description = "User data to run on instances"
    default = ""
}

variable "http_port" {
    description = "http port for instances"
    default = "80"
}

variable "loadbalancer_name" {
    description = "Display Name for loadbalancer"
    default = ""
}

variable "loadbalancer_shape" {
    description = "Display Name for loadbalancer"
    default = ""
}

variable "primary_loadbalancer_ad" {
    description = "Availability Domain for primary loadbalancer"
    default = ""
}

variable "primary_loadbalancer_subnet" {
    description = "Subnet on which primary loadbalancer will be created"
    default = ""
}

variable "primary_loadbalancer_name" {
    description = "Display Name for primary loadbalancer"
    default = ""
}

variable "standby_loadbalancer_ad" {
    description = "Availability Domain for standby loadbalancer"
    default = ""
}

variable "standby_loadbalancer_subnet" {
    description = "Subnet on which standby loadbalancer will be created"
    default = ""
}

variable "standby_loadbalancer_name" {
    description = "Display Name for standby loadbalancer"
    default = ""
}

variable "loadbalancer_instance_shape" {
    description = "Instance shape for loadbalancer instances"
    default = ""
}

variable "loadbalancer_instance_image_id" {
  description = "The OCID of an image for loadbalancer instance to use."
  default     = ""
}

variable "loadbalancer_ssh_public_key_file" {
  description = "Public SSH keys for the default user on the loadbalancer instance."
  default     = ""
}

variable "loadbalancer_ssh_private_key_file" {
  description = "Private SSH keys file path to login into the loadbalancer instance."
  default     = ""
}

variable "lb_hostname1" {
  description = "Hostname for loadbalancer instance1 to use in backendset"
  default     = ""
}

variable "lb_hostname2" {
  description = "Hostname for loadbalancer instance2 to use in backendset"
  default     = ""
}

variable "lb_hostname3" {
  description = "Hostname for loadbalancer instance3 to use in backendset"
  default     = ""
}

variable "user_data" {
  description = "User data script for the loadbalancer instance"
  default = "scripts/user_data.sh"
}

variable "subnet_ids" {
  type = "list"
  description = "Subnet IDs for the load balancer"
  default = []
}

/*locals {
  tcp_protocol  = "6"
  all_protocols = "all"
  anywhere      = "0.0.0.0/0"
}*/

