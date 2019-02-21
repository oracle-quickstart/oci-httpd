#!/bin/bash -x
echo '################### webserver userdata begins #####################'
touch ~opc/userdata.`date +%s`.start
# echo '########## yum update all ###############'
# yum update -y
echo '########## basic webserver ##############'
yum install -y httpd
semanage port -a -t http_port_t -p tcp ${lb_listen_port}
sed -i -e "s/Listen 80/Listen ${lb_listen_port}/" /etc/httpd/conf/httpd.conf
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
firewall-cmd --zone=public --permanent --add-port=${lb_listen_port}/tcp
firewall-cmd --reload
touch ~opc/userdata.`date +%s`.finish
echo '################### webserver userdata ends #######################'

