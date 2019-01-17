# Oracle Cloud Infrastructure Apache HTTP Server Terraform Module

## About
The Apache Http Server Oracle Cloud Infrastructure Module installs a Terraform-based Apache Http server on Oracle Cloud Infrastructure (OCI). An apache http server module typically involves installing three http server on different availablity domains with load balancer.

## Prerequisites
1. See the [Oracle Cloud Infrastructure Terraform Provider docs](https://www.terraform.io/docs/providers/oci/index.html) for information about setting up and using the Oracle Cloud Infrastructure Terraform Provider.
2. An existing VCN with subnets(private and public). The public subnets need internet access in order to download required dependent packages for Apache Http server installations.

![Apache Http Server architecture](https://confluence.oci.oraclecorp.com/rest/gliffy/1.0/embeddedDiagrams/59657898-3d7d-48c3-807d-cb4f338f0142.png)

## What's a Module?
A module is a canonical, reusablem definition for how to run a single piece of infrastructure, such as a database or server cluster. Each module is created using Terraform, and includes automated tests, examples, and documentation. It is maintained both by the open source community and companies that provide commercial support.

Instead of figuring out the details of how to run a piece of infrastructure from scratch, you can reuse existing code that has been proven in production. And instead of maintaining all that infrastructure code yourself, you can leverage the work of the module community to pick up infrastructure improvements through a version number bump.

## How to use this Module
Each Module has the following folder structure:
* [root](): Contains a root module which calls bastion, apache_http and load_balancer sub-modules respcetively to create a Apache Http server with load balancer in OCI.
* [modules](): Contains the reusable code for this module, broken down into one or more modules.
* [examples](): Contains examples of how to use the modules.

The following code shows how to deploy Apache HTTP servers using this module:

```txt
module "apache_http" {
  source              = "git::ssh://git@REPO_FQDN:7999/tfs/terraform-oci-apache-http.git?ref=dev"
  availability_domain   = "${var.availabillity_domain}"
  compartment_ocid      = "${var.compartment_ocid}"
  display_name          = "${var.display_name}"
  image_id              = "${var.image_id}"
  shape                 = "${var.shape}"
  label_prefix          = "_1"
  subnet_id             = "${var.subnet_id}"
  http_port             = "${var.http_port}"
  https_port            = "${var.https_port}"
  enable_https          = "${var.enable_https}"
  create_selfsigned_cert= "${var.create_selfsigned_cert}"
  cn_name               = "${var.cn_name}"
  ca_cert               = "${var.apache_server_ca_certificate}"
  pub_cert              = "${var.apache_server_public_certificate}"
  priv_key              = "${var.apache_server_private_key}"
  ssh_public_key_file   = "${var.ssh_public_key_file}"
  ssh_private_key_file  = "${var.ssh_private_key_file}"
  user_data             = "${var.user_data}"
  scripts               = "${var.scripts}"
  bastion_host          = "${var.bastion.public_ip}"
  bastion_user          = "${var.bastion_user}"
  bastion_private_key   = "${var.bastion_private_key_file}"
}

```

Argument | Description
--- | ---
availability_domain | Availability domain for the http server instance to be created.
compartment_ocid | OCID of the compartment where VCN will be created.
ssh_authorized_keys | Public SSH keys path to be included in the `~/.ssh/authorized_keys` file for the default user on the instance.
ssh_private_key | Private key path to access the instance.
label_prefix | Used to create unique identifiers to differentiate  multiple clusters in a compartment.
subnet_id | OCID of the master subnet in which to create the VNIC.
display_name | Name of the Http server instance.
image_id | OCID of an image for an instance to use. For more information, see [Oracle Cloud Infrastructure: Images](https://docs.cloud.oracle.com/iaas/images/).
shape | Shape to be used on the master instance.
user_data | Provide your own base64-encoded data to be used by `Cloud-Init` to run custom scripts or provide custom `Cloud-Init` configuration for master instance.
http_port | Port for HTTP traffic.
enable_https | Enable HTTPs in the backend Apache HTTP server.
https_port | Port for HTTPs traffic.
create_selfsigned_cert | Mention True to create selfsigned certificate else mention false.
cn_name | Common Name to be used during tls certificate creation.
ca_cert | CA Certificate to be used in backend Apache HTTP server.
pub_cert | Public Certificate to be used in backend Apache HTTP server.
priv_key| Private Key to be used in backend Apache HTTP server.

Possible combinations of Apache HTTP server configuration:
---
1. HTTP only
 Required variables declaration:
 * enable_https | false 
 Below variables need not be populated with values.
 * https_port
 * create_selfsigned_cert
 * cn_name
 * ca_cert
 * pub_cert
 * priv_key

2. HTTPs with self-signed certificate
 Required variables declaration:
 * enable_https | true
 * https_port | if not defined, default port will be configured.
 * create_selfsigned_cert | true
 Below variables need not be populated with values.
 * cn_name
 * ca_cert
 * pub_cert
 * priv_key
  
3. HTTPs with user defined ca_certificate
 Required variables declaration:
 * enable_https | true
 * https_port | if not defined, default port will be configured.
 * create_selfsigned_cert | false
 * cn_name | Common Name to be used during tls certificate creation.
 * ca_cert | CA Certificate to be used in backend Apache HTTP server.
 * pub_cert | Public Certificate to be used in backend Apache HTTP server.
 * priv_key| Private Key to be used in backend Apache HTTP server.


## Contributing

This project is open source. Oracle appreciates any contributions that are made by the open source community.

## Security

	https://httpd.apache.org/docs/2.4/misc/security_tips.html
	https://www.owasp.org/index.php/SCG_WS_Apache

## License

Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.

Licensed under the Universal Permissive License 1.0 or Apache License 2.0.

See [LICENSE](https://REPO_FQDN/projects/TFS/repos/terraform-oci-apache-http/browse/LICENSE.md?at=apache_http) for more details.
