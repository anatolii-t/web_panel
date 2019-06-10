#!/bin/bash
#--------VARIABLES START--------#
site_name=$1
php_version=$2
ssl_enabled=$3
backup_enabled=$4
#--------VARIABLES END----------#

. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector


action_perfomed="add_site"

#Check variables
if [ -z $1 ] || [ -z $2 ] || [ -z $3 ] || [ -z $4 ]
then
  echo -e '\\tERROR! NOT ALL WARIABLES DEFINED!' | logging show
  echo -e 'Usage: add_site.sh site_name php_version ssl_enabled backup_enabled'
  sleep 3
  exit 1
fi

site_owner=$panel_user

###----Block for admin----
if [ "$check_permission_admin" = "1" ] || [ $panel_user = "root" ]
then
  if [ -z $5 ]
  then
    echo -e "ERROR! Admin can't add site without owner! Add fifth variable" | logging show
    sleep 5
    exit 1
  fi

  site_owner=$5

  start_message="START ADDING SITE $site_name. Properties: PHP_VERSION:$php_version|SSL_ENABLED:$ssl_enabled|BACKUP ENABLED:$backup_enabled|OWNER:$site_owner"
  echo "\\t$start_message" | logging

  #check user is exist
  user_in_panel_exist=`mysql_connector "SELECT * FROM users WHERE name='$site_owner'" | wc -l`
  if [ $user_in_panel_exist = "0" ]
  then
    error_message="ERROR! User $site_owner does not exist in panel!" 
    echo "\\t$error_message" | logging show
    echo "Exiting after 5 seconds..."
    sleep 5
    exit 1
  fi
else
  start_message="START ADDING SITE $site_name. Properties: PHP_VERSION:$php_version|SSL_ENABLED:$ssl_enabled|BACKUP ENABLED:$backup_enabled"
  echo "\\t$start_message" | logging
fi
###----#----###

#check site in panel 
site_in_panel_exist=`mysql_connector "SELECT * FROM sites WHERE name='$site_name'" | wc -l`
if [ $site_in_panel_exist = "1" ]
then
  error_message="ERROR! Site $site_name already exist in panel!" 
  echo "\\t$error_message" | logging show
  echo "Exiting after 5 seconds..."
  sleep 5
  exit 1
fi

#check existing conf files Nginx
if [ -f /etc/nginx/vhosts/$site_owner/$site_name ]
then
  error_message="ERROR! Nginx conf file for $site_name already exist!" 
  echo "\\t$error_message" | logging show
  echo "Exiting after 5 seconds..."
  sleep 5
  exit 1
fi  
#check existing conf files Apache
if [ -f /etc/httpd/vhosts/$site_owner/$site_name ]
then
  error_message="ERROR! Apache conf file for $site_name already exist!"         
  echo "\\t$error_message" | logging show
  echo "Exiting after 5 seconds..."
  sleep 5
  exit 1
fi
#check existing site dir
if [ -d /var/www/$site_owner/www/$site_name ]
then
  error_message="ERROR! Directory for $site_name already exist!"
  echo "\\t$error_message" | logging show
  echo "Exiting after 5 seconds..."
  sleep 5
  exit 1
fi  
#check existing log files
if [ -f /var/www/$site_owner/logs/nginx/${site_name}_access.log ]
then
  error_message="ERROR! Nginx log file for $site_name already exist!"
  echo "\\t$error_message" | logging show
  echo "Exiting after 5 seconds..."
  sleep 5
  exit 1
fi
if [ -f /var/www/$site_owner/logs/nginx/${site_name}_error.log ]
then
  error_message="ERROR! Nginx log file for $site_name already exist!"
  echo "\\t$error_message" | logging show
  echo "Exiting after 5 seconds..."
  sleep 5
  exit 1
fi

if [ -f /var/www/$site_owner/logs/httpd/${site_name}_requests.log ]
then
  error_message="ERROR! Apache log file for $site_name already exist!"
  echo "\\t$error_message" | logging show
  echo "Exiting after 5 seconds..."
  sleep 5
  exit 1
fi

if [ -f /var/www/$site_owner/logs/httpd/${site_name}_error.log ]
then
  error_message="ERROR! Apache log file for $site_name already exist!"
  echo "\\t$error_message" | logging show
  echo "Exiting after 5 seconds..."
  sleep 5
  exit 1
fi


  
#Creating dir
mkdir -p -m 755 /var/www/$site_owner/www/$site_name
if [ $? = "1" ]  
then
  error_message="ERROR! Cant create dir for $site_name"
  echo "\\t$error_message" | logging show
  echo "Exiting after 5 seconds..."
  sleep 5
  exit 1
fi

#Creating conf Nginx
if [ $ssl_enabled = "y" ]
then
  while true
  do
    read -p "Which type of certificate use? (self-signed / existing) " type_ssl
    case "$type_ssl" in
      "self-signed" )
      openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl_certificates/${site_owner}/${site_name}.key -out /etc/nginx/ssl_certificates/${site_owner}/${site_name}.chained.crt 
      ;;
      "existing" ) 
      echo "Enter crt after 5 seconds and save it..."
      sleep 5
      nano /var/www/$site_owner/tmp/${site_name}.crt
       
      echo "Enter bundle after 5 seconds and save it..."
      sleep 5
      nano /var/www/$site_owner/tmp/${site_name}.bundle
      echo "Enter private key after 5 seconds and save it..."
      sleep 5
      nano /var/www/$site_owner/tmp/${site_name}.key

      cat /var/www/$site_owner/tmp/${site_name}.crt /var/www/$site_owner/tmp/${site_name}.bundle > /etc/nginx/ssl_certificates/${site_owner}/${site_name}.chained.crt
      cat /var/www/$site_owner/tmp/${site_name}.key > /etc/nginx/ssl_certificates/${site_owner}/${site_name}.key

      rm -f /var/www/$site_owner/tmp/${site_name}.crt /var/www/$site_owner/tmp/${site_name}.bundle /var/www/$site_owner/tmp/${site_name}.key
      ;;
      * ) if [ $wrong_count = "2" ]
        then
          error_message="ERROR! You entered wrong argument in cert type 3 times."
          echo "\\t$error_message" | logging show
          echo "Exiting after 5 seconds..."
          sleep 5
          exit 1
        else
          echo 'Pleas type "self-signed" or "existing"' 
          wrong_count=$[ $wrong_count + 1 ]
          continue
        fi;;
    esac
    wrong_count=0
    break
  done

  touch /etc/nginx/vhosts/$site_owner/$site_name
  used_template=`cat /usr/local/panel/src/conf_templates/nginx_ssl.template`
  eval "echo \"$used_template\"" > /etc/nginx/vhosts/$site_owner/${site_name}.conf
  nginx -t > /dev/null 2>>$panel_log
  if [ $? = "1" ]
  then
    error_message="ERROR! Created conf does not valid. Check conf!"
    echo "\\t$error_message" | logging show
  else
    systemctl reload nginx > /dev/null 2>>$panel_log
  fi
else
  touch /etc/nginx/vhosts/$site_owner/$site_name
  used_template=`cat /usr/local/panel/src/conf_templates/nginx.template`
  eval "echo \"$used_template\"" > /etc/nginx/vhosts/$site_owner/${site_name}.conf
  nginx -t > /dev/null 2>>$panel_log
  if [ $? = "1" ]
  then
    error_message="ERROR! Created conf does not valid. Check conf!"
    echo "\\t$error_message" | logging show
  else
    systemctl reload nginx > /dev/null 2>>$panel_log
  fi
fi

#Creating apache conf
touch /etc/httpd/vhosts/$site_owner/$site_name
  used_template=`cat /usr/local/panel/src/conf_templates/apache.template`
  eval "echo \"$used_template\"" > /etc/httpd/vhosts/$site_owner/${site_name}.conf
  httpd -t > /dev/null 2>>$panel_log
  if [ $? = "1" ]
  then
    error_message="ERROR! Created conf does not valid. Check conf!"
    echo "\\t$error_message" | logging show
  else
    systemctl reload httpd > /dev/null 2>>$panel_log
  fi
#Creating php_version file
case "$php_version" in
  "5.6(Apache)") echo "" > /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf;;
  "5.4(CGI)") cat /etc/httpd/php_versions/php54.conf > /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf;;
  "5.5(CGI)") cat /etc/httpd/php_versions/php55.conf > /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf;;
  "5.6(CGI)") cat /etc/httpd/php_versions/php56.conf > /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf;;
  "7.0(CGI)") cat /etc/httpd/php_versions/php70.conf > /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf;;
  "7.1(CGI)") cat /etc/httpd/php_versions/php71.conf > /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf;;
  "7.2(CGI)") cat /etc/httpd/php_versions/php72.conf > /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf;;
  "7.3(CGI)") cat /etc/httpd/php_versions/php73.conf > /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf;; 
esac

httpd -t > /dev/null 2>>$panel_log
  if [ $? = "1" ]
  then
    error_message="ERROR! Created conf does not valid. Check conf!"
    echo "\\t$error_message" | logging show
  else
    systemctl reload httpd > /dev/null 2>>$panel_log
  fi

  
#Creating database record
mysql_connector "INSERT INTO sites VALUES ('${site_name}', '${site_owner}', '${php_version}', '${ssl_enabled}', '${backup_enabled}')"

message="OK! Site '$site_name' successfully created!"
echo "\\t$message" | logging show
sleep 3
exit 0
