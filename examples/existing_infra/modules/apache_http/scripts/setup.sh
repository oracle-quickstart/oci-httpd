#!/bin/bash -x
echo 'Apache HTTP server installation started!'
sudo service httpd status
sudo yum -y install httpd
sudo service httpd start
sudo service httpd enable
sudo service httpd status
sudo firewall-cmd --zone=public --permanent --add-port=80/tcp
sudo firewall-cmd --reload
sudo sh -c "echo \"It works !!!($1)\" > /var/www/html/index.html"
echo 'Installation done'

