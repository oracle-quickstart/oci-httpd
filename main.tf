#########################################################
# Apache HTTP server deployment
#########################################################
module "bastion" {
  source               = "./modules/bastion"
  availability_domain  = "${var.bastion_ad}"
  compartment_ocid     = "${var.compartment_ocid}"
  display_name         = "${var.bastion_hostname}"
  image_id             = "${var.bastion_image_id}"
  shape                = "${var.bastion_shape}"
  subnet_id            = "${var.bastion_subnet_id}"
  ssh_public_key_file  = "${var.bastion_public_key_file}"
  ssh_private_key_file = "${var.bastion_private_key_file}"
}

module "apache_http_server1" {
  source                 = "./modules/apache_http"
  availability_domain    = "${var.instance_ad1}"
  compartment_ocid       = "${var.compartment_ocid}"
  display_name           = "${var.instance_name}"
  image_id               = "${var.instance_image_id}"
  shape                  = "${var.instance_shape}"
  label_prefix           = "_1"
  subnet_id              = "${var.instance_subnet1_id}"
  http_port              = "${var.http_port}"
  https_port             = "${var.https_port}"
  enable_https           = "${var.enable_https}"
  create_selfsigned_cert = "${var.create_selfsigned_cert}"
  server_cnname          = "${module.apache_load_balancer.loadbalancer_ip[0]}"
  selfsigned_ca_cert     = "${module.apache_load_balancer.ca_certificate}"
  selfsigned_priv_key    = "${module.apache_load_balancer.private_key}"
  cn_name                = "${var.cn_name}"
  ca_cert                = "${var.apache_server_ca_certificate}"
  priv_key               = "${var.apache_server_private_key}"
  ssh_public_key_file    = "${var.ssh_public_key_file}"
  ssh_private_key_file   = "${var.ssh_private_key_file}"
  scripts                = "${var.instance_scripts}"
  bastion_host           = "${module.bastion.public_ip}"
  bastion_user           = "${var.bastion_user}"
  bastion_private_key    = "${var.bastion_private_key_file}"
}

module "apache_http_server2" {
  source                 = "./modules/apache_http"
  availability_domain    = "${var.instance_ad2}"
  compartment_ocid       = "${var.compartment_ocid}"
  display_name           = "${var.instance_name}"
  image_id               = "${var.instance_image_id}"
  shape                  = "${var.instance_shape}"
  label_prefix           = "_2"
  subnet_id              = "${var.instance_subnet2_id}"
  http_port              = "${var.http_port}"
  https_port             = "${var.https_port}"
  enable_https           = "${var.enable_https}"
  create_selfsigned_cert = "${var.create_selfsigned_cert}"
  server_cnname          = "${module.apache_load_balancer.loadbalancer_ip[0]}"
  selfsigned_ca_cert     = "${module.apache_load_balancer.ca_certificate}"
  selfsigned_priv_key    = "${module.apache_load_balancer.private_key}"
  cn_name                = "${var.cn_name}"
  ca_cert                = "${var.apache_server_ca_certificate}"
  priv_key               = "${var.apache_server_private_key}"
  ssh_public_key_file    = "${var.ssh_public_key_file}"
  ssh_private_key_file   = "${var.ssh_private_key_file}"
  scripts                = "${var.instance_scripts}"
  bastion_host           = "${module.bastion.public_ip}"
  bastion_user           = "${var.bastion_user}"
  bastion_private_key    = "${var.bastion_private_key_file}"
}

module "apache_http_server3" {
  source                 = "./modules/apache_http"
  availability_domain    = "${var.instance_ad3}"
  compartment_ocid       = "${var.compartment_ocid}"
  display_name           = "${var.instance_name}"
  image_id               = "${var.instance_image_id}"
  shape                  = "${var.instance_shape}"
  label_prefix           = "_3"
  subnet_id              = "${var.instance_subnet3_id}"
  http_port              = "${var.http_port}"
  https_port             = "${var.https_port}"
  enable_https           = "${var.enable_https}"
  create_selfsigned_cert = "${var.create_selfsigned_cert}"
  server_cnname          = "${module.apache_load_balancer.loadbalancer_ip[0]}"
  selfsigned_ca_cert     = "${module.apache_load_balancer.ca_certificate}"
  selfsigned_priv_key    = "${module.apache_load_balancer.private_key}"
  cn_name                = "${var.cn_name}"
  ca_cert                = "${var.apache_server_ca_certificate}"
  priv_key               = "${var.apache_server_private_key}"
  ssh_public_key_file    = "${var.ssh_public_key_file}"
  ssh_private_key_file   = "${var.ssh_private_key_file}"
  scripts                = "${var.instance_scripts}"
  bastion_host           = "${module.bastion.public_ip}"
  bastion_user           = "${var.bastion_user}"
  bastion_private_key    = "${var.bastion_private_key_file}"
}

module "apache_load_balancer" {
  source                = "./modules/load_balancer"
  compartment_ocid      = "${var.compartment_ocid}"
  subnet_ids            = ["${var.primary_loadbalancer_subnet}", "${var.standby_loadbalancer_subnet}"]
  display_name          = "${var.loadbalancer_name}"
  shape                 = "${var.loadbalancer_shape}"
  http_port             = "${var.http_port}"
  https_port            = "${var.https_port}"
  enable_https          = "${var.enable_lb_https}"
  lb_ca_certificate     = "${var.loadbalancer_ca_certificate}"
  lb_public_certificate = "${var.loadbalancer_public_certificate}"
  lb_private_key        = "${var.loadbalancer_private_key}"
  host_address          = "${module.apache_load_balancer.loadbalancer_ip[0]}"
  hostname1             = "${var.lb_hostname1}"
  hostname2             = "${var.lb_hostname2}"
  hostname3             = "${var.lb_hostname3}"
  hostname1_ip          = "${module.apache_http_server1.private_ip}"
  hostname2_ip          = "${module.apache_http_server2.private_ip}"
  hostname3_ip          = "${module.apache_http_server3.private_ip}"
}
