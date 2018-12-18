#!/bin/bash -x
echo 'Apache HTTP server installation started!'
sudo service httpd status
sudo yum -y install httpd
sudo semanage port -a -t http_port_t -p tcp ${http_port}
sudo sed -i -e "s/Listen 80/Listen ${http_port}/" /etc/httpd/conf/httpd.conf
sudo grep 'Listen ' /etc/httpd/conf/httpd.conf > ~/check.txt
sudo service httpd start
sudo service httpd enable
sudo service httpd status
sudo firewall-cmd --zone=public --permanent --add-port=${http_port}/tcp
sudo firewall-cmd --reload
sudo sh -c "echo \"It works !!!($1)\" > /var/www/html/index.html"
echo 'Installation done'

