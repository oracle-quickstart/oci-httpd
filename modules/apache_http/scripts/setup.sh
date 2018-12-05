#!/bin/bash -x
echo 'Apache HTTP server installation started!'
sudo service httpd status
sudo yum -y install httpd
sudo semanage port -a -t http_port_t -p tcp $1
sudo sed -i -e "s/Listen 80/Listen $1/" /etc/httpd/conf/httpd.conf
sudo grep 'Listen ' /etc/httpd/conf/httpd.conf > ~/check.txt
sudo service httpd start
sudo service httpd enable
sudo service httpd status
sudo firewall-cmd --zone=public --permanent --add-port=$1/tcp
sudo firewall-cmd --reload
sudo sh -c "echo \"It works !!!($2)\" > /var/www/html/index.html"
echo 'Installation done'

