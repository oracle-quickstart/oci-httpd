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
if [ "${enable_https}" == "true" ]; then
  echo 'Apache HTTPs server with openssl ... '
  sudo yum -y install mod_ssl
  sudo yum -y install httpd24-mod_ssl
  :'sudo openssl req -x509 -nodes -days 3 -subj "/C=US/ST=Ca/L=Sunnydale/CN=${cn_name}" -newkey rsa:1024 -keyout prikey.pem -out cert.pem
  sudo openssl x509 -in cert.pem -out rootcert.crt
  '
  sudo mkdir /etc/httpd/conf/ssl
  sudo cp ${ca_cert} /etc/httpd/conf/ssl/cert.pem
  sudo cp ${priv_key} /etc/httpd/conf/ssl/prikey.pem
  sudo cp ${ca_cert} /etc/httpd/conf/ssl/root_cert.pem
  sudo restorecon -RvF /etc/httpd/conf/ssl
  sudo firewall-cmd --zone=public --permanent --add-port=${https_port}/tcp
  sudo firewall-cmd --reload
  sudo semanage port -m -t http_port_t -p tcp ${https_port}
  sudo sed -i  "/Listen 443 https/c\
    #Listen 443 https\n\
    Listen ${https_port}\n\
    <VirtualHost *:${https_port}>\n\
        ServerName ${cn_name}\n\
        SSLEngine on\n\
        SSLCertificateFile \"/etc/httpd/conf/ssl/cert.pem\"\n\
        SSLCertificateKeyFile \"/etc/httpd/conf/ssl/prikey.pem\"\n\
    </VirtualHost>\n\
    " /etc/httpd/conf.d/ssl.conf
  sudo apachectl configtest
  sudo apachectl restart
fi
echo 'Installation done'

