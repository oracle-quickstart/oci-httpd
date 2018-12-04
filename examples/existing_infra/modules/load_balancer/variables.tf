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
variable "ssh_public_key_file" {}
variable "ssh_private_key_file" {}
variable "hostname1" {}
variable "hostname2" {}
variable "hostname3" {}
variable "hostname1_ip" {}
variable "hostname2_ip" {}
variable "hostname3_ip" {}
variable "user_data" {
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
