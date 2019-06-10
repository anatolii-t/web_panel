#!/bin/bash

#--------VARIABLES START--------#
os_name=`cat /etc/os-release | grep ^'ID=' | awk -F \" '{print $2}'`
os_version=`cat /etc/os-release | grep ^'VERSION_ID=' | awk -F \" '{print $2}'`
os_full_info=`echo $os_name$os_version  | tr '[:lower:]' '[:upper:]'`
panel_main_dir=/usr/local/panel
panel_log_dir=$panel_main_dir/log
install_log=$panel_log_dir/install.log
panel_log=$panel_log_dir/panel.log
#src - for confs tenmplates
#var - for panel's files
#bin - for panl's scripts
panel_src_dir=$panel_main_dir/src
panel_var_dir=$panel_main_dir/var
panel_bin_dir=$panel_main_dir/bin
installation_date=`date "+%Y-%m-%d"`
#--------VARIABLES END--------#

#--------SCRIPT'S BODY START--------#


function chmoding_file {
  chown root:root $1
  chmod 640 $1
}

function chmoding_dir {
  chown root:root $1
  chmod 750 $1
}

function write_install_log {
  showing_flag=$1
  while read -r text
  do
    LOGTIME=`date "+%Y-%m-%d %H:%M:%S"`
    # If log file is not defined, just echo the output
    if [ "$install_log" == "" ] && [ "$showing_flag" == "show" ]; then
      echo -e [$LOGTIME]":"[$text];
    else
        if [ ! -f $install_log ]; then echo "ERROR!! Cannot find file $install_log. Exiting."; exit 1; fi
        #if need show message in terminal with time and other information 
        #echo [$LOGTIME][$text][$SUDO_USER] | tee -a $LOG;
        if [ "$showing_flag" == "show" ]; then
          echo -e $text
        fi
        echo -e [$LOGTIME]":"$text >> $install_log
      fi
  done
}


#Check OS type and version
if [ "$os_full_info" != "CENTOS7" ]
then
  echo -e "\tERROR! Your OS is not supported. Exiting now!"
  exit 1
fi

#Check and create panel dir
if ! [ -d $panel_main_dir ]
then
  mkdir $panel_main_dir
  chmoding_dir $panel_main_dir
else
  echo -e "\tWARNING! Panel dir \"$panel_main_dir\" already exist, recreating dir..."
  rm -rf $panel_main_dir
  mkdir $panel_main_dir
  chmoding_dir $panel_main_dir
  recreating_panel_main_dir=1
fi
#Check and create panel log dir
if ! [ -d $panel_log_dir ]
then
  mkdir $panel_log_dir
  chmoding_dir $panel_log_dir
else
  echo -e "\tWARNING! Panel log dir \"$panel_log_dir\" already exist, recreating dir..."
  rm -rf $panel_log_dir
  mkdir $panel_log_dir
  chmoding_dir $panel_log_dir
  recreating_panel_log_dir=1
fi


#Check and create additionl dirs for panel
#src - for confs tenmplates
#var - for panel's files
#bin - for panl's scripts

#Check and create panel src dir
if ! [ -d $panel_src_dir ]
then
  mkdir $panel_src_dir
  chmoding_dir $panel_src_dir
else
  echo -e "\tWARNING! Panel src dir \"$panel_src_dir\" already exist, recreating dir..."
  rm -rf $panel_src_dir
  mkdir $panel_src_dir
  chmoding_dir $panel_src_dir
fi

#Check and create panel var dir
if ! [ -d $panel_var_dir ]
then
  mkdir $panel_var_dir
  chmoding_dir $panel_var_dir
else
  echo -e "\tWARNING! Panel var dir \"$panel_var_dir\" already exist, recreating dir..."
  rm -rf $panel_var_dir
  mkdir $panel_var_dir
  chmoding_dir $panel_var_dir
fi

#Check and create panel bin dir
if ! [ -d $panel_bin_dir ]
then
  mkdir $panel_bin_dir
  chmoding_dir $panel_bin_dir
else
  echo -e "\tWARNING! Panel bin dir \"$panel_bin_dir\" already exist, recreating dir..."
  rm -rf $panel_bin_dir
  mkdir $panel_bin_dir
  chmoding_dir $panel_bin_dir
fi

#Check and create panel log file
if ! [ -f $panel_log ]
then
  touch $panel_log
  chmoding_file $panel_bin_dir
else
  echo -e "\tWARNING! Panel log dir \"$panel_log\" already exist, recreating dir..."
  rm -rf $panel_log
  touch $panel_log
  chmoding_file $panel_bin_dir
fi


#Check and create install log file
echo "Creating log file before installing..."
if ! [ -f $install_log ]
then
  touch $install_log
  chmoding_file $install_log
  echo -e "\tOK! Log file created"
else
  echo -e "\tWARNING! Install log file \"$install_log\" already exist, recreating file..." 
  rm -rf $install_log
  touch $install_log
  chmoding_file $install_log
  echo -e "\tOK! Log file created"
fi

#Check and create backup directory
if ! [ -d /backup ]
then
  mkdir /backup
  chmoding_dir /backup
else
  echo -e "\tWARNING! Directory for backup already exist, recreating dir..." 
  mv /backup /backup_orig_$installation_date
  mkdir /backup
  chmoding_dir /backup
fi
#backup dir for panel
if ! [ -d /backup/panel ]
then
  mkdir /backup/panel
  chmoding_dir /backup/panel
else
  echo -e "\tWARNING! Directory for panel backup already exist, recreating dir..." 
  rm -rf /backup/panel
  mkdir /backup/panel
  chmoding_dir /backup/panel
fi
#backup dir for user's
if ! [ -d /backup/users ]
then
  mkdir /backup/users
  chmoding_dir /backup/users
else
  echo -e "\tWARNING! Directory for users backup already exist, recreating dir..." 
  rm -rf /backup/users
  mkdir /backup/users
  chmoding_dir /backup/users
fi

#dir for admins
if ! [ -d /home/admins ]
then
  mkdir /home/admins
  chmoding_dir /home/admins
else
  echo -e "\tWARNING! Directory for admins already exist, recreating dir..." 
  rm -rf /home/admins
  mkdir /home/admins
  chmoding_dir /home/admins
fi

#dir for users
if ! [ -d /var/www ]
then
  mkdir /var/www
  chmoding_dir /var/www
fi

#Logging start information
echo "---Starting istall panel---" | write_install_log show
#Writing old WARNINGS in log if its need
if [ "$recreating_panel_main_dir" = "1" ]
then
  message="\\tWARNING! Panel dir \"$panel_main_dir\" already exist, recreating dir..."
  echo $message | write_install_log
fi
if [ "$recreating_panel_log_dir" = "1" ]
then
 message="\\tWARNING! Panel log dir \"$panel_log_dir\" already exist, recreating dir..."
 echo $message | write_install_log
fi


#istall iptables-services and stop iptables if need
if [ -f /usr/sbin/iptables ]
then
  echo "Installing iptables-services and stop iptables..." | write_install_log show
  yum -y install iptables-services > /dev/null 2>>$install_log
  if [ $? != "0" ]
  then
    echo -e '\\tERROR! Iptables-services cant be installed. Please, check log and retry install. Exiting!' | write_install_log show
    exit 1
  fi
  systemctl enable iptables > /dev/null 2>>$install_log
  systemctl stop iptables > /dev/null 2>>$install_log
  if [ $? != "0" ]
  then
    echo -e '\\tERROR! Iptables cant be stopped. PLease, check log and retry install. Exiting!' | write_install_log show
    exit 1
  fi
  echo -e '\\tOK! iptables-services installed and iptables stoped' | write_install_log show
fi

#Istalling repos
echo "Start installing repositories" | write_install_log show
echo "Try install Epel repo..." | write_install_log show
if ! [ -f /etc/yum.repos.d/epel.repo ]
then 
  echo "Epel repo is not installed yet. Installing..." | write_install_log show
  rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm > /dev/null 2>>$install_log
  if [ "$?" != "0" ]
  then 
    echo -e '\\tERROR! Epel repo wasnt installed. Plesae, check log and retry install. Exiting!' | write_install_log show
    exit 1
  fi
  echo -e '\\tOK! Epel repo installed!' | write_install_log show
else
  echo -e '\\tWARNING! Epel repo already installed' | write_install_log show
fi


echo "Try install Remi repo..." | write_install_log show
if ! [ -f /etc/yum.repos.d/remi.repo ]
then 
  echo "Remi repo is not installed yet. Installing..." | write_install_log show
  rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm > /dev/null 2>>$install_log
  if [ "$?" != "0" ]
  then
    echo -e '\\tERROR! Remi repo wasnt installed. Please check log and retry install. Exiting!' | write_install_log show
    exit 1
  fi
  echo -e '\\tOK! Remi repo installed!' | write_install_log show
else
  echo -e '\\tWARNING! Remi repo already installed' | write_install_log show
fi

echo "Repoitories installed" | write_install_log show

#Installing nginx
echo "Installing Nginx..." | write_install_log show
if [ -f /usr/sbin/nginx ]
then
  echo -e '\\tERROR! Nginx already installed. Exiting!' | write_install_log show
  exit 1
fi
yum -y install nginx > /dev/null 2>>$install_log
if [ $? != "0" ]
then 
  echo -e '\\tERROR! Nginx was not installed. Please check log and retry install. Exiting!' | write_install_log show
  exit 1
fi
systemctl stop nginx > /dev/null
systemctl enable nginx > /dev/null 2>>$install_log
echo -e '\\tOK! Nginx installed' | write_install_log show


echo "Editing nginx.conf..." | write_install_log show

echo "user nginx;
worker_processes 2;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;

    reset_timedout_connection on;
    client_header_timeout 15;
    client_body_timeout 30;
    send_timeout 15;

    keepalive_timeout   30;

    keepalive_requests 10;
    client_max_body_size 32m;
    limit_rate_after 50M;
    limit_rate 300K;
    open_file_cache max=10000 inactive=5m;
    open_file_cache_min_uses 5;
    open_file_cache_valid 1m;

    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;
    
    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
        }
	include /etc/nginx/conf.aditional/*.conf;
        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
    include /etc/nginx/vhosts/*/*.conf;
}

" > /etc/nginx/nginx.conf
if [ -d /etc/nginx/conf.aditional ]
then
  echo '\\tWARNING! Dir for aditional Nginx confs already exist. Recreating it!' | write_install_log show
  rm -rf /etc/nginx/conf.aditional
  mkdir /etc/nginx/conf.aditional
else
  mkdir /etc/nginx/conf.aditional
fi

if [ -d /etc/nginx/vhosts ]
then
  echo '\\tWARNING! Dir for Virtual hosts confs for Nginx already exist. Recreating it!' | write_install_log show
  rm -rf /etc/nginx/vhosts
  mkdir /etc/nginx/vhosts
else
  mkdir /etc/nginx/vhosts
fi

if [ -d /etc/nginx/ssl_certificates ]
then
  echo '\\tWARNING! Dir for SSL Certificates for Nginx already exist. Recreating it!' | write_install_log show
  rm -rf /etc/nginx/ssl_certificates
  mkdir /etc/nginx/ssl_certificates
else
  mkdir /etc/nginx/ssl_certificates
fi

#Create Diffie–Hellman key
echo "Creating Diffie–Hellman key" | write_install_log show
openssl dhparam -out /etc/nginx/ssl_certificates/dhparam.pem 4096

echo "Nginx conf edited" | write_install_log show
echo "Starting Nginx..." | write_install_log show
systemctl start nginx > /dev/null 2>>$install_log
if [ $? == "1" ]
then
  echo -e '\\tWARNING! Nginx not start corectly. Please, check logs after install.' | write_install_log show
else
  echo -e '\\tOK! Nginx started.' | write_install_log show
fi


#Installing Apache
echo "Installing Apache..." | write_install_log show
if [ -f /usr/sbin/httpd ]
then
  echo -e '\\tERROR! Apache already installed. Exiting!' | write_install_log show
  exit 1
fi
yum -y install httpd httpd-itk mod_ssl > /dev/null 2>>$install_log
if [ $? != "0" ]
then
  echo -e '\\tERROR! Apache was not installed. Please check log and retry install. Exiting!' | write_install_log show
  exit 1
fi
systemctl stop httpd > /dev/null
systemctl enable httpd > /dev/null 2>>$install_log
echo -e '\\tOK! Apache installed' | write_install_log show



echo "Editing Apache conf..." | write_install_log show

sed -i 's|Listen 80|Listen 8080|' /etc/httpd/conf/httpd.conf
sed -i 's|%h|%a|g' /etc/httpd/conf/httpd.conf

echo "RemoteIPHeader X-Forwarded-For
RemoteIPTrustedProxy 127.0.0.1


<Ifmodule itk.c>
StartServers       1
MinSpareServers    1
MaxSpareServers   5
ServerLimit      20
MaxClients       100
MaxRequestsPerChild  400
</Ifmodule>

IncludeOptional conf.aditional/*.conf
IncludeOptional vhosts/*/*.conf
" >> /etc/httpd/conf/httpd.conf

if [ ! -d /etc/httpd/conf.aditional ]
then 
  mkdir /etc/httpd/conf.aditional
else 
  echo '\\tWARNING! Dir for aditional Apache confs already exist. Recreating it!' | write_install_log show
  rm -rf /etc/httpd/conf.aditional
  mkdir /etc/httpd/conf.aditional
fi

if [ ! -d /etc/httpd/php_versions ]
then
  mkdir /etc/httpd/php_versions
else
  echo '\\tWARNING! Dir for aditional PHP Versions confs already exist. Recreating it!' | write_install_log show
  rm -rf /etc/httpd/php_versions
  mkdir /etc/httpd/php_versions
fi

if [ ! -d /etc/httpd/vhosts ]
then
  mkdir /etc/httpd/vhosts
else
  echo '\\tWARNING! Dir for virtual hosts confs already exist. Recreating it!' | write_install_log show
  rm -rf /etc/httpd/vhosts
  mkdir /etc/httpd/vhosts
fi

if [ ! -d /etc/httpd/vhosts_php ]
then
  mkdir /etc/httpd/vhosts_php
else
  echo '\\tWARNING! Dir for virtual hosts confs already exist. Recreating it!' | write_install_log show
  rm -rf /etc/httpd/vhosts_php
  mkdir /etc/httpd/vhosts_php
fi

echo "LoadModule mpm_itk_module modules/mod_mpm_itk.so" >> /etc/httpd/conf.modules.d/00-mpm-itk.conf

mv /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf_original

echo "Apache conf edited" | write_install_log show
echo "Starting Apache..." | write_install_log show
systemctl start httpd > /dev/null 2>>$install_log
if [ $? == "1" ]
then
  echo -e '\\tWARNING! Apache not start corectly. Please, check logs after install.' | write_install_log show
else
  echo -e '\\tOK! Apache started.' | write_install_log show
fi



#Installing MySQL server
echo "Installing MySQL server..." | write_install_log show
if [ -f /usr/bin/mysql ]
then
  echo -e '\\tERROR! MySQL server already installed. Exiting!' | write_install_log show
  exit 1
fi
yum -y install mariadb mariadb-server > /dev/null 2>>$install_log
if [ $? != "0" ]
then
  echo -e '\\tERROR! MySQL server was not installed. Please check log and retry install. Exiting!' | write_install_log show
  exit 1
fi
systemctl stop mariadb > /dev/null
systemctl enable mariadb > /dev/null 2>>$install_log
echo -e '\\tOK! MySQL server installed' | write_install_log show

echo "Starting MySQL server..." | write_install_log show
systemctl start mariadb > /dev/null 2>>$install_log
if [ $? == "1" ]
then
  echo -e '\\tWARNING! MySQL server not start corectly. Please, check logs after install.' | write_install_log show
else
  echo -e '\\tOK! Mysql server started.' | write_install_log show
fi

#Install system programms
echo "Install system programms" | write_install_log
yum -y install zip unzip pwgen rsync psmisc > /dev/null 2>>$install_log
echo "System programms installed" | write_install_log

#Configuring MySQL server
echo "Start configuring MySQL server..." | write_install_log show
mysql_password=`pwgen -cns -N 1 21`
mysqladmin -u root password $mysql_password > /dev/null 2>>$install_log
echo "
[client]
user = root
password = $mysql_password
" > /root/.my.cnf

echo "
[client]
default-character-set = utf8
socket = /var/lib/mysql/mysql.sock

[mysqld]
init_connect='SET collation_connection = utf8_unicode_ci'
character_set_server=utf8
collation_server = utf8_unicode_ci

datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
symbolic-links=0
innodb_file_per_table=0
max_connections=50
max_allowed_packet = 32M
key_buffer_size = 128M
thread_cache_size=64
sort_buffer_size = 2M
read_buffer_size = 2M
bulk_insert_buffer_size = 16M
tmp_table_size = 32M
max_heap_table_size = 32M

# * MyISAM

table_open_cache = 4096
read_rnd_buffer_size = 1M
myisam_sort_buffer_size = 128M

# * Query Cache Configuration

query_cache_size = 64M
query_cache_limit = 2MB

skip-networking

[mysqld_safe]
log-error=/var/log/mariadb/mariadb.log
pid-file=/var/run/mariadb/mariadb.pid

[myisamchk]
key_buffer_size = 8M
sort_buffer_size = 8M


!includedir /etc/my.cnf.d

" > /etc/my.cnf

systemctl restart mariadb > /dev/null 2>>$install_log
if [ $? != "0" ]
then
  echo -e '\\tERROR! MySQL server cant be configuring correctly. Exiting now! (Pleas check installation log for more information)' | write_install_log show
  exit 1
fi

echo "Deleting DB \"test\"..." | write_install_log show
mysql -e "drop database test;" > /dev/null 2>>$install_log
if [ $? != "0" ]
then
  echo -e '\\tWARNING! Test DB in MySQL server was not deleted. Please, check it.' | write_install_log show
else
  echo -e '\\tOK! Test DB was deleted successfully' | write_install_log show
fi

echo "Creating panel DB..." | write_install_log show
if [ -d /var/lib/mysql/panel_db ]
then
  echo -e '\\tWARNING! Panel DB in MySQL already exist. Recreating it...' | write_install_log show
  mysql -e "drop database panel_db;" > /dev/null 2>>$install_log
fi
mysql -e "create database panel_db;" > /dev/null 2>>$install_log
if [ $? != "0" ]
then
  echo -e '\\tERROR! Panel DB cant be created. Exiting!' | write_install_log show
  exit 1
fi
echo -e '\\tOK! Panel DB was created successfully' | write_install_log show

#Function for connect to panel database
function connect {
  mysql -D panel_db -u root -Bse "$1"
}

#Creating panel DB's tables
echo "Creating panel DB's tables..." | write_install_log show
connect "create table users (name VARCHAR(16), PRIMARY KEY (name));"
connect "create table admins (name VARCHAR(16), PRIMARY KEY (name));"
connect "create table sites (name VARCHAR(255), owner VARCHAR(16), php_version VARCHAR(11), ssl_enable ENUM('y', 'n') NOT NULL DEFAULT 'n', backup ENUM('y', 'n') NOT NULL DEFAULT 'n', PRIMARY KEY (name));"
connect "create table data_bases (name VARCHAR(64), owner VARCHAR(16), users VARCHAR(88), backup ENUM('y', 'n') NOT NULL DEFAULT 'n', PRIMARY KEY (name));"
connect "create table data_bases_users (name VARCHAR(16), owner VARCHAR(16), PRIMARY KEY (name));"
connect "create table ftp_users (name VARCHAR(64), owner VARCHAR(16), dir VARCHAR(600), PRIMARY KEY (name));"
echo -e '\\tOK! Panel DB was created successfully' | write_install_log show

#Installing module_apache PHP Version (5.6) 
if [ -f /usr/bin/php ]
then
  echo -e '\\tERROR! PHP Already installed. Exiting!' | write_install_log show
  exit 1
fi

echo "Installing Apache module PHP Version (5.6)..." | write_install_log show
yum -y --disablerepo=* --enablerepo=remi --enablerepo=epel --enablerepo=remi-php56 --enablerepo=base install php php-bcmath php-cli php-common php-gd php-gmp php-imap php-intl php-ioncube-loader php-mbstring php-mcrypt php-mysqlnd php-odbc php-opcache php-pdo php-xcache php-xml php-pecl-apcu php-pecl-imagick php-pecl-jsonc php-pecl-yaml php-pecl-zip php-pecl-geoip > /dev/null 2>>$install_log

if [ $? != "0" ]
then
  echo -e '\\tERROR! PHP 5.6 as module Apache cant installed. Exiting!' | write_install_log show
  exit 1
fi

echo -e '\\tOK! PHP 5.6 as module Apache installed successfully' | write_install_log show
#Creating file with instaled versions PHP (as module Apache)
if [ ! -f $panel_var_dir/php_versions ]
then
  touch $panel_var_dir/php_versions
  chmoding_file $panel_var_dir/php_versions
else
 rm -f $panel_var_dir/php_versions
 touch $panel_var_dir/php_versions
 chmoding_file $panel_var_dir/php_versions
fi
echo '5.6(Apache)' > $panel_var_dir/php_versions

echo "Restarting Apache..."
systemctl restart httpd > /dev/null 2>>$install_log
if [ $? != "0" ]
then
  echo -e '\\tWARNING! Apache cant reload and start. Check apache status!' | write_install_log show
else
  echo -e '\\tOK! Apache restarted successfully' | write_install_log show
fi

#Installing aditional PHP versions (as CGI; 5.4,5.5,5.6,7.0,7.1,7.2,7.3)
echo "Installing aditional PHP versions (as CGI)..." | write_install_log show

#Intalling PHP 5.4 CGI
echo "Installing PHP 5.4..." | write_install_log show
if [ -d /opt/remi/php54 ]
then
  echo -e '\\tWARNING! PHP 5.4 already installed, skipping it!' | write_install_log show
else
  yum -y --disablerepo=* --enablerepo=updates --enablerepo=remi-safe --enablerepo=epel --enablerepo=base install php54-php php54-php-bcmath php54-php-cli php54-php-common php54-php-gd php54-php-imap php54-php-intl php54-php-ioncube-loader php54-php-mbstring php54-php-mcrypt php54-php-mysqlnd php54-php-pdo php54-php-pecl-apcu php54-php-pecl-crypto php54-php-pecl-geoip php54-php-pecl-imagick php54-php-pecl-ip2location php54-php-pecl-jsonc php54-php-pecl-memcache php54-php-pecl-memcached php54-php-pecl-memprof php54-php-pecl-yaml php54-php-pecl-zip php54-php-soap php54-php-xcache php54-php-xml > /dev/null 2>>$install_log
  if [ $? != "0" ]
  then 
    echo -e '\\tWARNING! PHP 5.4 cant be installed, skipping it! (For more information check install log)' | write_install_log show
  else
    mv /etc/httpd/conf.d/php54-php.conf /etc/httpd/conf.d/php54-php.conf_bk
    mv /etc/httpd/conf.modules.d/10-php54-php.conf /etc/httpd/conf.modules.d/10-php54-php.conf_bk
    if [ ! -d /var/www/php-alt ]
    then
      mkdir /var/www/php-alt
    fi
    if [ ! -d /var/www/php-alt/php54 ]
    then
      mkdir /var/www/php-alt/php54
    fi 
    if [ ! -f /var/www/php-alt/php54/php ]
    then
      touch /var/www/php-alt/php54/php
      chmod 555 /var/www/php-alt/php54/php
      echo "#!/opt/remi/php54/root/usr/bin/php-cgi" > /var/www/php-alt/php54/php
    else
      echo "#!/opt/remi/php54/root/usr/bin/php-cgi" > /var/www/php-alt/php54/php
      chmod 555 /var/www/php-alt/php54/php
    fi
    echo "5.4(CGI)" >> $panel_var_dir/php_versions
    if [ -f /etc/httpd/php_versions/php54.conf ]
    then
      echo -e '\\tWARNING! Configuration file for Apache for version 5.4 already exist! Skip creating it' | write_install_log show
    else
      echo '<FilesMatch "\.ph(p[3-5]?|tml)$">
SetHandler application/x-httpd-php54
</FilesMatch>
ScriptAlias /php-bin/ /var/www/php-alt/php54/
AddHandler application/x-httpd-php54 .php .php3 .php4 .php5 .phtml
Action application/x-httpd-php54 /php-bin/php' > /etc/httpd/php_versions/php54.conf
    fi
    echo -e '\\tOK! PHP 5.4 Installed!' | write_install_log show
  fi
fi



#Intalling PHP 5.5 CGI
echo "Installing PHP 5.5..." | write_install_log show
if [ -d /opt/remi/php55 ]
then
  echo -e '\\tWARNING! PHP 5.5 already installed, skipping it!' | write_install_log show
else
  yum -y --disablerepo=* --enablerepo=updates --enablerepo=remi-safe --enablerepo=epel --enablerepo=base install php55-php php55-php-bcmath php55-php-cli php55-php-common php55-php-gd php55-php-imap php55-php-intl php55-php-ioncube-loader php55-php-mbstring php55-php-mcrypt php55-php-mysqlnd php55-php-opcache php55-php-pdo php55-php-pecl-apcu php55-php-pecl-crypto php55-php-pecl-geoip php55-php-pecl-imagick php55-php-pecl-ip2location php55-php-pecl-jsonc php55-php-pecl-memcache php55-php-pecl-memcached php55-php-pecl-memprof php55-php-pecl-yaml php55-php-pecl-zip php55-php-soap php55-php-xcache php55-php-xml  > /dev/null 2>>$install_log
  if [ $? != "0" ]
  then
    echo -e '\\tWARNING! PHP 5.5 cant be installed, skipping it! (For more information check install log)' | write_install_log show
  else
    mv /etc/httpd/conf.d/php55-php.conf /etc/httpd/conf.d/php55-php.conf_bk
    mv /etc/httpd/conf.modules.d/10-php55-php.conf /etc/httpd/conf.modules.d/10-php55-php.conf_bk
    if [ ! -d /var/www/php-alt ]
    then
      mkdir /var/www/php-alt
    fi
    if [ ! -d /var/www/php-alt/php55 ]
    then
      mkdir /var/www/php-alt/php55
    fi
    if [ ! -f /var/www/php-alt/php55/php ]
    then
      touch /var/www/php-alt/php55/php
      chmod 555 /var/www/php-alt/php55/php
      echo "#!/opt/remi/php55/root/usr/bin/php-cgi" > /var/www/php-alt/php55/php
    else
      echo "#!/opt/remi/php55/root/usr/bin/php-cgi" > /var/www/php-alt/php55/php
      chmod 555 /var/www/php-alt/php55/php
    fi
    echo "5.5(CGI)" >> $panel_var_dir/php_versions
    if [ -f /etc/httpd/php_versions/php55.conf ]
    then
      echo -e '\\tWARNING! Configuration file for Apache for version 5.5 already exist! Skip creating it' | write_install_log show
    else
      echo '<FilesMatch "\.ph(p[3-5]?|tml)$">
SetHandler application/x-httpd-php55
</FilesMatch>
ScriptAlias /php-bin/ /var/www/php-alt/php55/
AddHandler application/x-httpd-php55 .php .php3 .php4 .php5 .phtml
Action application/x-httpd-php55 /php-bin/php' > /etc/httpd/php_versions/php55.conf 
    fi
    echo -e '\\tOK! PHP 5.5 Installed!' | write_install_log show
  fi
fi


#Intalling PHP 5.6 CGI
echo "Installing PHP 5.6..." | write_install_log show
if [ -d /opt/remi/php56 ]
then
  echo -e '\\tWARNING! PHP 5.6 already installed, skipping it!' | write_install_log show
else
  yum -y --disablerepo=* --enablerepo=updates --enablerepo=remi-safe --enablerepo=epel --enablerepo=base install php56-php php56-php-bcmath php56-php-cli php56-php-common php56-php-gd php56-php-imap php56-php-intl php56-php-ioncube-loader php56-php-mbstring php56-php-mcrypt php56-php-mysqlnd php56-php-opcache php56-php-pdo php56-php-pecl-apcu php56-php-pecl-crypto php56-php-pecl-geoip php56-php-pecl-imagick php56-php-pecl-ip2location php56-php-pecl-jsonc php56-php-pecl-memcache php56-php-pecl-memcached php56-php-pecl-memprof php56-php-pecl-yaml php56-php-pecl-zip php56-php-process php56-php-soap php56-php-xcache php56-php-xml  > /dev/null 2>>$install_log
  if [ $? != "0" ]
  then
    echo -e '\\tWARNING! PHP 5.6 cant be installed, skipping it! (For more information check install log)' | write_install_log show
  else
    mv /etc/httpd/conf.d/php56-php.conf /etc/httpd/conf.d/php56-php.conf_bk
    mv /etc/httpd/conf.modules.d/10-php56-php.conf /etc/httpd/conf.modules.d/10-php56-php.conf_bk
    if [ ! -d /var/www/php-alt ]
    then
      mkdir /var/www/php-alt
    fi
    if [ ! -d /var/www/php-alt/php56 ]
    then
      mkdir /var/www/php-alt/php56
    fi
    if [ ! -f /var/www/php-alt/php56/php ]
    then
      touch /var/www/php-alt/php56/php
      chmod 555 /var/www/php-alt/php56/php
      echo "#!/opt/remi/php56/root/usr/bin/php-cgi" > /var/www/php-alt/php56/php
    else
      echo "#!/opt/remi/php56/root/usr/bin/php-cgi" > /var/www/php-alt/php56/php
      chmod 555 /var/www/php-alt/php56/php
    fi
    echo "5.6(CGI)" >> $panel_var_dir/php_versions
    if [ -f /etc/httpd/php_versions/php56.conf ]
    then
      echo -e '\\tWARNING! Configuration file for Apache for version 5.6 already exist! Skip creating it' | write_install_log show
    else
      echo '<FilesMatch "\.ph(p[3-5]?|tml)$">
SetHandler application/x-httpd-php56
</FilesMatch>
ScriptAlias /php-bin/ /var/www/php-alt/php56/
AddHandler application/x-httpd-php56 .php .php3 .php4 .php5 .phtml
Action application/x-httpd-php56 /php-bin/php' > /etc/httpd/php_versions/php56.conf 
    fi
    echo -e '\\tOK! PHP 5.6 Installed!' | write_install_log show
  fi
fi




#Intalling PHP 7.0 CGI
echo "Installing PHP 7.0..." | write_install_log show
if [ -d /opt/remi/php70 ]
then
  echo -e '\\tWARNING! PHP 7.0 already installed, skipping it!' | write_install_log show
else
  yum -y --disablerepo=* --enablerepo=updates --enablerepo=remi-safe --enablerepo=epel --enablerepo=base install php70-php php70-php-bcmath php70-php-cli php70-php-common php70-php-gd php70-php-imap php70-php-intl php70-php-ioncube-loader php70-php-json php70-php-mbstring php70-php-mcrypt php70-php-mysqlnd php70-php-opcache php70-php-pdo php70-php-pecl-apcu php70-php-pecl-decimal php70-php-pecl-geoip php70-php-pecl-imagick php70-php-pecl-inotify php70-php-pecl-ip2location php70-php-pecl-memcache php70-php-pecl-memcached php70-php-pecl-memprof php70-php-pecl-mysql php70-php-pecl-yaml php70-php-pecl-zip php70-php-soap php70-php-xml  > /dev/null 2>>$install_log
  if [ $? != "0" ]
  then
    echo -e '\\tWARNING! PHP 7.0 cant be installed, skipping it! (For more information check install log)' | write_install_log show
  else
    mv /etc/httpd/conf.d/php70-php.conf /etc/httpd/conf.d/php70-php.conf_bk
    mv /etc/httpd/conf.modules.d/15-php70-php.conf /etc/httpd/conf.modules.d/15-php70-php.conf_bk
    if [ ! -d /var/www/php-alt ]
    then
      mkdir /var/www/php-alt
    fi
    if [ ! -d /var/www/php-alt/php70 ]
    then
      mkdir /var/www/php-alt/php70
    fi
    if [ ! -f /var/www/php-alt/php70/php ]
    then
      touch /var/www/php-alt/php70/php
      chmod 555 /var/www/php-alt/php70/php
      echo "#!/opt/remi/php70/root/usr/bin/php-cgi" > /var/www/php-alt/php70/php
    else
      echo "#!/opt/remi/php70/root/usr/bin/php-cgi" > /var/www/php-alt/php70/php
      chmod 555 /var/www/php-alt/php70/php
    fi
    echo "7.0(CGI)" >> $panel_var_dir/php_versions
    if [ -f /etc/httpd/php_versions/php70.conf ]
    then
      echo -e '\\tWARNING! Configuration file for Apache for version 7.0 already exist! Skip creating it' | write_install_log show
    else
      echo '<FilesMatch "\.ph(p[3-5]?|tml)$">
SetHandler application/x-httpd-php70
</FilesMatch>
ScriptAlias /php-bin/ /var/www/php-alt/php70/
AddHandler application/x-httpd-php70 .php .php3 .php4 .php5 .phtml
Action application/x-httpd-php70 /php-bin/php' > /etc/httpd/php_versions/php70.conf
    fi
    echo -e '\\tOK! PHP 7.0 Installed!' | write_install_log show
  fi
fi



#Intalling PHP 7.1 CGI
echo "Installing PHP 7.1..." | write_install_log show
if [ -d /opt/remi/php71 ]
then
  echo -e '\\tWARNING! PHP 7.1 already installed, skipping it!' | write_install_log show
else
  yum -y --disablerepo=* --enablerepo=updates --enablerepo=remi-safe --enablerepo=epel --enablerepo=base install php71-php php71-php-bcmath php71-php-cli  php71-php-common php71-php-gd php71-php-imap php71-php-intl php71-php-ioncube-loader php71-php-json php71-php-mbstring php71-php-mcrypt php71-php-mysqlnd php71-php-opcache php71-php-pdo php71-php-pecl-apcu php71-php-pecl-geoip php71-php-pecl-imagick php71-php-pecl-ip2location php71-php-pecl-memcache php71-php-pecl-memcached php71-php-pecl-memprof php71-php-pecl-mysql  php71-php-pecl-yaml php71-php-pecl-zip php71-php-soap php71-php-xml  > /dev/null 2>>$install_log
  if [ $? != "0" ]
  then
    echo -e '\\tWARNING! PHP 7.1 cant be installed, skipping it! (For more information check install log)' | write_install_log show
  else
    mv /etc/httpd/conf.d/php71-php.conf /etc/httpd/conf.d/php71-php.conf_bk
    mv /etc/httpd/conf.modules.d/15-php71-php.conf /etc/httpd/conf.modules.d/15-php71-php.conf_bk
    if [ ! -d /var/www/php-alt ]
    then
      mkdir /var/www/php-alt
    fi
    if [ ! -d /var/www/php-alt/php71 ]
    then
      mkdir /var/www/php-alt/php71
    fi
    if [ ! -f /var/www/php-alt/php71/php ]
    then
      touch /var/www/php-alt/php71/php
      chmod 555 /var/www/php-alt/php71/php
      echo "#!/opt/remi/php71/root/usr/bin/php-cgi" > /var/www/php-alt/php71/php
    else
      echo "#!/opt/remi/php71/root/usr/bin/php-cgi" > /var/www/php-alt/php71/php
      chmod 555 /var/www/php-alt/php71/php
    fi
    echo "7.1(CGI)" >> $panel_var_dir/php_versions
    if [ -f /etc/httpd/php_versions/php71.conf ]
    then
      echo -e '\\tWARNING! Configuration file for Apache for version 7.1 already exist! Skip creating it' | write_install_log show
    else
      echo '<FilesMatch "\.ph(p[3-5]?|tml)$">
SetHandler application/x-httpd-php71
</FilesMatch>
ScriptAlias /php-bin/ /var/www/php-alt/php71/
AddHandler application/x-httpd-php71 .php .php3 .php4 .php5 .phtml
Action application/x-httpd-php71 /php-bin/php' > /etc/httpd/php_versions/php71.conf
    fi
    echo -e '\\tOK! PHP 7.1 Installed!' | write_install_log show
  fi
fi





#Intalling PHP 7.2 CGI
echo "Installing PHP 7.2..." | write_install_log show
if [ -d /opt/remi/php72 ]
then
  echo -e '\\tWARNING! PHP 7.2 already installed, skipping it!' | write_install_log show
else
  yum -y --disablerepo=* --enablerepo=updates --enablerepo=remi-safe --enablerepo=epel --enablerepo=base install php72-php php72-php-bcmath php72-php-cli php72-php-common php72-php-gd php72-php-imap php72-php-intl php72-php-ioncube-loader php72-php-json php72-php-mbstring php72-php-mysqlnd php72-php-opcache php72-php-pdo php72-php-pecl-apcu php72-php-pecl-crypto php72-php-pecl-decimal php72-php-pecl-geoip php72-php-pecl-imagick php72-php-pecl-ip2location php72-php-pecl-mcrypt php72-php-pecl-memcache php72-php-pecl-memcached php72-php-pecl-memprof php72-php-pecl-mysql php72-php-pecl-rar php72-php-pecl-yaml php72-php-pecl-zip php72-php-process php72-php-soap php72-php-xml > /dev/null 2>>$install_log
  if [ $? != "0" ]
  then
    echo -e '\\tWARNING! PHP 7.2 cant be installed, skipping it! (For more information check install log)' | write_install_log show
  else
    mv /etc/httpd/conf.d/php72-php.conf /etc/httpd/conf.d/php72-php.conf_bk
    mv /etc/httpd/conf.modules.d/15-php72-php.conf /etc/httpd/conf.modules.d/15-php72-php.conf_bk
    if [ ! -d /var/www/php-alt ]
    then
      mkdir /var/www/php-alt
    fi
    if [ ! -d /var/www/php-alt/php72 ]
    then
      mkdir /var/www/php-alt/php72
    fi
    if [ ! -f /var/www/php-alt/php72/php ]
    then
      touch /var/www/php-alt/php72/php
      chmod 555 /var/www/php-alt/php72/php
      echo "#!/opt/remi/php72/root/usr/bin/php-cgi" > /var/www/php-alt/php72/php
    else
      echo "#!/opt/remi/php72/root/usr/bin/php-cgi" > /var/www/php-alt/php72/php
      chmod 555 /var/www/php-alt/php72/php
    fi
    echo "7.2(CGI)" >> $panel_var_dir/php_versions
    if [ -f /etc/httpd/php_versions/php72.conf ]
    then
      echo -e '\\tWARNING! Configuration file for Apache for version 7.2 already exist! Skip creating it' | write_install_log show
    else
      echo '<FilesMatch "\.ph(p[3-5]?|tml)$">
SetHandler application/x-httpd-php72
</FilesMatch>
ScriptAlias /php-bin/ /var/www/php-alt/php72/
AddHandler application/x-httpd-php72 .php .php3 .php4 .php5 .phtml
Action application/x-httpd-php72 /php-bin/php' > /etc/httpd/php_versions/php72.conf
    fi
    echo -e '\\tOK! PHP 7.2 Installed!' | write_install_log show
  fi
fi


#Intalling PHP 7.3 CGI
echo "Installing PHP 7.3..." | write_install_log show
if [ -d /opt/remi/php73 ]
then
  echo -e '\\tWARNING! PHP 7.3 already installed, skipping it!' | write_install_log show
else
  yum -y --disablerepo=* --enablerepo=updates --enablerepo=remi-safe --enablerepo=epel --enablerepo=base install php73-php php73-php-bcmath php73-php-cli php73-php-common php73-php-gd php73-php-imap php73-php-intl php73-php-ioncube-loader php73-php-json php73-php-mbstring php73-php-mysqlnd php73-php-opcache php73-php-pdo php73-php-pecl-apcu php73-php-pecl-crypto php73-php-pecl-geoip php73-php-pecl-imagick php73-php-pecl-ip2location php73-php-pecl-mcrypt php73-php-pecl-memcache php73-php-pecl-memcached php73-php-pecl-memprof php73-php-pecl-mysql php73-php-pecl-rar php73-php-pecl-yaml php73-php-pecl-zip php73-php-process php73-php-soap php73-php-xml php73-runtime > /dev/null 2>>$install_log
  if [ $? != "0" ]
  then
    echo -e '\\tWARNING! PHP 7.3 cant be installed, skipping it! (For more information check install log)' | write_install_log show
  else
    mv /etc/httpd/conf.d/php73-php.conf /etc/httpd/conf.d/php73-php.conf_bk
    mv /etc/httpd/conf.modules.d/15-php73-php.conf /etc/httpd/conf.modules.d/15-php73-php.conf_bk
    if [ ! -d /var/www/php-alt ]
    then
      mkdir /var/www/php-alt
    fi
    if [ ! -d /var/www/php-alt/php73 ]
    then
      mkdir /var/www/php-alt/php73
    fi
    if [ ! -f /var/www/php-alt/php73/php ]
    then
      touch /var/www/php-alt/php73/php
      chmod 555 /var/www/php-alt/php73/php
      echo "#!/opt/remi/php73/root/usr/bin/php-cgi" > /var/www/php-alt/php73/php
    else
      echo "#!/opt/remi/php73/root/usr/bin/php-cgi" > /var/www/php-alt/php73/php
      chmod 555 /var/www/php-alt/php73/php
    fi
    echo "7.3(CGI)" >> $panel_var_dir/php_versions
    if [ -f /etc/httpd/php_versions/php73.conf ]
    then
      echo -e '\\tWARNING! Configuration file for Apache for version 7.3 already exist! Skip creating it' | write_install_log show
    else
      echo '<FilesMatch "\.ph(p[3-5]?|tml)$">
SetHandler application/x-httpd-php73
</FilesMatch>
ScriptAlias /php-bin/ /var/www/php-alt/php73/
AddHandler application/x-httpd-php73 .php .php3 .php4 .php5 .phtml
Action application/x-httpd-php73 /php-bin/php' > /etc/httpd/php_versions/php73.conf
    fi
    echo -e '\\tOK! PHP 7.3 Installed!' | write_install_log show
  fi
fi
echo "All PHP versions installed!" | write_install_log show

#Installing ProFTPd
echo "Installing ProFTPd..." | write_install_log show
if [ -f /usr/sbin/proftpd ]
then
  echo -e '\\tWARNING! ProFTPd already installed. Skiping it!' | write_install_log show
else
  yum -y install proftpd proftpd-utils > /dev/null 2>>$install_log
  if [ $? != "0" ]
  then 
    echo -e '\\tWARNING! ProFTPd cant be installed, skipping it! (For more information check install log)' | write_install_log show
  else
    sed -i '87d' /etc/proftpd.conf && sed -i '86a\LoadModule mod_auth_file.c' /etc/proftpd.conf && sed -i '87a\AuthOrder mod_auth_file.c' /etc/proftpd.conf
    echo "AuthUserFile /etc/ftpd.passwd 
RequireValidShell off 
AuthPAM off 
RootLogin off" >> /etc/proftpd.conf
    if [ -f /etc/ftpd.passwd ]
    then
      echo -e '\\tWARNING! Passwd file /etc/ftpd.passwd for ProFTPd already exist, recreating it!' | write_install_log show
      mv /etc/ftpd.passwd /etc/ftpd.passwd_or_$installation_date
      touch /etc/ftpd.passwd
      chgrp nobody /etc/ftpd.passwd
      chmod 640 /etc/ftpd.passwd
    else
      touch /etc/ftpd.passwd
      chgrp nobody /etc/ftpd.passwd
      chmod 640 /etc/ftpd.passwd
    fi
    systemctl enable proftpd > /dev/null 2>>$install_log
    systemctl restart proftpd
    if [ $? != "0" ]
    then
      echo -e '\\tWARNING! ProFTPd installed, but cant be restarted correctly. (For more information check install log and status of service)' | write_install_log show
    else
      echo -e '\\tOK! ProFTPd installed!' | write_install_log show
    fi
  fi
fi



#PHPMyAdmin
echo "Start instal phpMyAdmin..." | write_install_log show
wget -q https://files.phpmyadmin.net/phpMyAdmin/4.8.5/phpMyAdmin-4.8.5-all-languages.zip 2>>$install_log
if [ $? != "0" ]
then
  echo '\\tWARNING! Cant downloading phpMyAdmin. It will not be installed!' 
else
  unzip phpMyAdmin-4.8.5-all-languages.zip -d /usr/share
  mv /usr/share/phpMyAdmin-4.8.5-all-languages /usr/share/phpMyAdmin
  chown -R apache: /usr/share/phpMyAdmin
  #Apache conf for phpMyAdmin
  echo '
Alias /phpmyadmin /usr/share/phpMyAdmin
<Directory /usr/share/phpMyAdmin>
        <IfModule itk.c>
                AssignUserID apache apache
        </IfModule>
        <IfModule mpm_itk_module>
                AssignUserID apache apache
        </IfModule>
        Order allow,deny
        Allow from all
        Options FollowSymLinks
        DirectoryIndex index.php
        <IfModule php5_module>
                AddType application/x-httpd-php .php  .php3 .php4 .php5 .phtml
                <IfVersion >= 2.4>
                        # Bug on centos-7 with open_basedir restriction and doc/html/index.html check
                        php_flag error_reporting E_NONE
                </IfVersion>
                php_flag magic_quotes_gpc Off
                php_flag track_vars On
                php_flag register_globals Off
                php_admin_flag allow_url_fopen Off
                php_admin_flag engine on
                php_value include_path .
                php_admin_value upload_tmp_dir /tmp
                php_admin_value open_basedir "/usr/share/phpMyAdmin/:/etc/phpMyAdmin/:/var/lib/phpMyAdmin/upload:/tmp/:/usr/share/php/:/var/lib/php/session/:/opt/php53/share/pear:/opt/php54/share/pear:/opt/php55/share/pear:/opt/php56/share/pear:/var/lib/phpMyAdmin/temp/:doc/html/index.html"
                php_admin_value session.save_path "/var/lib/php/session"
                php_admin_value mbstring.func_overload 0
        </IfModule>
        RemoveHandler .php .php3 .php4 .phtml
        <FilesMatch "\.ph(p[3-5]?|tml)$">
                SetHandler application/x-httpd-php
        </FilesMatch>
        <IfVersion >= 2.4>
                AllowOverride None
                Require all granted
        </IfVersion>
</Directory>
<Directory /usr/share/phpMyAdmin/setup>
        <IfModule mod_authz_core.c>
                # Apache 2.4
               <RequireAny>
                Require all denied
                </RequireAny>
        </IfModule>
        <IfModule !mod_authz_core.c>
                # Apache 2.2
                Order Deny,Allow
                Deny from All
        </IfModule>
</Directory>
' > /etc/httpd/conf.aditional/phpmyadmin.conf
  #Nginx conf for phpMyAdmin
  echo '
        location /phpmyadmin {
        alias /usr/share/phpMyAdmin;
        index index.php;
        }
        location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
        alias /usr/share/phpMyAdmin/$1;
        error_page 404 @apache;
        }
        location ~ ^/phpmyadmin/(.+\.php)$ {
        alias /usr/share/phpMyAdmin/$1;
        error_log /dev/null crit;
        proxy_pass http://127.0.0.1:8080;
        proxy_redirect http://127.0.0.1:8080 /;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        }

        location ^~ /phpmyadmin/setup {
        deny all;
        }

' > /etc/nginx/conf.aditional/phpmyadmin.conf
  #php settings for phpMyAdmin
  echo "
date.timezone = Europe/Moscow" >> /etc/php.ini
fi

systemctl restart nginx > /dev/null 2>>$install_log
if [ $? != "0" ]
then
  echo -e '\\tWARNING! Nginx was not reload correctly. Please, check install log for aditional information' | write_install_log show
fi

systemctl restart httpd > /dev/null 2>>$install_log
if [ $? != "0" ]
then
  echo -e '\\tWARNING! Apache was not reload correctly. Please, check install log for aditional information' | write_install_log show
fi





echo "Start configuring permissions for correct panel working..." | write_install_log show
#Creating group for panel_user's
if [ `grep -E '^panel_users:' /etc/group | wc -l` -gt 0 ]
then
  echo -e '\\tERROR! Group for panel users already exist. Exiting now!' | write_install_log show
  exit 1
fi
groupadd -r panel_users


#Modification sudoers
if [ -f /etc/sudoers ]
then
  mv /etc/sudoers /etc/sudoers_or_$installation_date
fi

echo 'root	ALL=(ALL) 	ALL
# %sys ALL = NETWORKING, SOFTWARE, SERVICES, STORAGE, DELEGATING, PROCESSES, LOCATE, DRIVERS
%wheel	ALL=(ALL)	NOPASSWD: ALL, !/usr/bin/passwd root, !/usr/sbin/visudo
#includedir /etc/sudoers.d
%panel_users  ALL=(root) NOPASSWD: /usr/local/panel/bin/user/delete_account_myself.sh, /usr/local/panel/bin/list_db.sh, /usr/local/panel/bin/list_db_users.sh, /usr/local/panel/bin/add_new_db.sh, /usr/local/panel/bin/delete_db_user.sh, /usr/local/panel/bin/add_user_in_db.sh, /usr/local/panel/bin/delete_db.sh, /usr/local/panel/bin/delete_user_from_db.sh, /usr/local/panel/bin/add_new_db_user.sh, /usr/local/panel/bin/add_new_ftp_user.sh, /usr/local/panel/bin/delete_ftp_user.sh, /usr/local/panel/bin/list_ftp_users.sh, /usr/local/panel/bin/panel_header.sh, /usr/local/panel/bin/list_www_properties.sh, /usr/local/panel/bin/change_php_version.sh, /usr/local/panel/bin/ssl_for_site.sh, /usr/local/panel/bin/backup_for_site.sh, /usr/local/panel/bin/list_www.sh, /usr/local/panel/bin/delete_site.sh, /usr/local/panel/bin/add_new_site.sh' > /etc/sudoers

chmod 440 /etc/sudoers
chown root:root /etc/sudoers

