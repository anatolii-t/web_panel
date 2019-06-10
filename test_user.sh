#!/bin/bash
user=test
site=test.com

useradd $user -b /var/www -m -U -s /sbin/nologin
usermod -a -G $user nginx
usermod -a -G $user apache
chmod 710 /var/www/$user

echo "Создаем директории"
mkdir -p -m 755 /var/www/$user/www
mkdir -p -m 755 /var/www/$user/logs/nginx/
mkdir -p -m 755 /var/www/$user/logs/httpd/
mkdir -p -m 777 /var/www/$user/tmp



echo "Пользователь добавлен"

echo ================================

echo "Создаем папку сайта"

mkdir -p -m 755 /var/www/$user/www/$site

echo "Создаем конфигурационный файл nginx"

touch /etc/nginx/conf.d/$site.conf

echo "
server { 
   listen 80; 
   server_name $site www.$site; 
   access_log /var/www/$user/logs/nginx/"$site"_access.log; 
   error_log /var/www/$user/logs/nginx/"$site"_error.log; 
 location / {
  proxy_pass http://127.0.0.1:8080/;
  proxy_read_timeout 300s;
  proxy_set_header Host \$http_host;
  proxy_set_header X-Real-IP \$remote_addr;
  proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
  proxy_pass_header Set-Cookie;
  proxy_buffering off;
  } 

 location ~* \.(css|js|png|gif|jpg|jpeg|ico)$ {
  root /var/www/$user/www/$site;
  expires 1d; 
 } 
 error_page 500 502 503 504 /50x.html;
 location = /50x.html 
 { root /usr/share/nginx/html; 
 } 
}

" > /etc/nginx/conf.d/$site.conf

systemctl restart nginx

echo "Конфигурационный файл Nginx создан"

echo "Создаем конф Апача"
touch /etc/httpd/conf.d/$site.conf

echo "
<VirtualHost *:8080> 
    ServerName $site 
    ServerAlias www.$site 
    DocumentRoot /var/www/$user/www/$site 
    AssignUserId $user $user
  <Directory "/var/www/$user/www"> 
   AllowOverride None 
   Require all granted 
  </Directory> 
 DirectoryIndex index.php 
 Include /etc/httpd/conf.d/${site}_php.conf
 ErrorLog /var/www/$user/logs/httpd/"$site"_error.log 
 CustomLog /var/www/$user/logs/httpd/"$site"_requests.log combined 
</VirtualHost>" > /etc/httpd/conf.d/$site.conf 

touch /etc/httpd/conf.d/${site}_php.conf
echo "<FilesMatch \"\.ph(p[3-5]?|tml)$\">
                SetHandler application/x-httpd-php72
 </FilesMatch>
 ScriptAlias /php-bin/ /var/www/php-alt/php72/
 AddHandler application/x-httpd-php72 .php .php3 .php4 .php5 .phtml
 Action application/x-httpd-php72 /php-bin/php" > /etc/httpd/conf.d/${site}_php.conf

echo "Коф.файл апача установлен"

systemctl restart httpd

touch /var/www/$user/www/$site/i.php

echo "
<?php
phpinfo();
?>" > /var/www/$user/www/$site/i.php

echo "
<?php
echo \"<div align=center>\";
echo \"=======================================================================<br><br>\";
echo \"USER: \";
echo \`/usr/bin/whoami\`;
echo \"<br><br>=======================================================================<br><br>\";
echo \" UID, GID, groups: \";
system (id);
echo \"<br><br>=======================================================================<br><br>\";
echo \`/usr/sbin/httpd.itk -l\`;
echo \"<br><br>=======================================================================<br><br>\";
echo \`/usr/sbin/apachectl -v\`;
echo \"<br><br>=======================================================================<br><br>\";
echo \"<dr><dr>\";
echo \"</div>\";
phpinfo();
?>
" > /var/www/$user/www/$site/tested.php

cd /var/www/$user/www/$site/
wget https://ru.wordpress.org/latest-ru_RU.zip
unzip latest-ru_RU.zip
mv /var/www/$user/www/$site/wordpress/* /var/www/$user/www/$site/

cd /root/
mysql -e "create database test_site"
db_pass="12345qwerty"
mysql -e "create user 'test_user'@'localhost' identified by '$db_pass';"
mysql -e "grant all privileges on test_site.* to 'test_user'@'localhost';"
mysql -e "flush privileges;"

chown -R $user:$user /var/www/$user/*


ftp_pass=`pwgen -cns -N 1 21`
echo ftp_pass=$ftp_pass
user_id=`id -u $user`
echo $ftp_pass | ftpasswd --stdin --passwd --name $user --uid $user_id --home /var/www/$user --shell /bin/false --file /etc/ftpd.passwd
systemctl reload proftpd
