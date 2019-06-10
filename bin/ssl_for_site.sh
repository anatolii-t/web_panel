#!/bin/bash

edited_site=$1
action=$2


. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector

action_perfomed="edit_ssl_status_site"

#Checking existing user in database
site_in_database_is_exist=`mysql_connector "SELECT * FROM sites WHERE name='$edited_site'" | wc -l`
if [ $site_in_database_is_exist -eq 0 ]
then
  message="ERROR! Site '$edited_site' not exist! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

#Checking existing user in system

check_current_status=`mysql_connector "SELECT ssl_enable FROM sites WHERE name='$edited_site'"`
if [ "$check_current_status" == "n" ]
then
  if [ "$action" == "disable_ssl" ]
  then
    message="ERROR! SSL for site '$edited_site' already disabled! Exiting now!"
    echo "\\t$message" | logging show
    sleep 5
    exit 1
  fi
else
  if [ "$action" == "enable_ssl" ]
  then
    message="ERROR! SSL for site '$edited_site' already enabled! Exiting now!"
    echo "\\t$message" | logging show
    sleep 5
    exit 1
  fi
fi

site_owner=`mysql_connector "select owner from sites where name='$edited_site';"`
#check owner
if [ "$check_permission_admin" != "1" ]
then
    if [ "$site_owner" != "$panel_user" ]
  then
  message="ERROR! Site '$edited_site' not belong to you! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
  fi
fi

#--------------------------------------------------------
function disable_ssl {
  rm /etc/nginx/ssl_certificates/${site_owner}/${edited_site}.chained.crt
  rm /etc/nginx/ssl_certificates/${site_owner}/${edited_site}.key  

  used_template=`cat /usr/local/panel/src/conf_templates/nginx.template`
  eval "echo \"$used_template\"" > /etc/nginx/vhosts/$site_owner/$edited_site
  nginx -t > /dev/null 2>>$panel_log
  if [ $? = "1" ]
  then
    error_message="ERROR! Created conf does not valid. Check conf!"
    echo "\\t$error_message" | logging show
  else
    systemctl reload nginx > /dev/null 2>>$panel_log
  fi

  mysql_connector "UPDATE sites SET ssl_enable='n' WHERE name='$site_name';"

  message="OK! SSL for '$site_name' disabled!"
  echo "\\t$message" | logging show
  sleep 3
}



function enable_ssl {
  while true
  do
    read -p "Which type of certificate use? (self-signed / existing) " type_ssl
    case "$type_ssl" in
      "self-signed" )
      openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl_certificates/${site_owner}/${edited_site}.key -out /etc/nginx/ssl_certificates/${site_owner}/${edited_site}.chained.crt
      ;;
      "existing" )
      echo "Enter crt after 5 seconds and save it..."
      sleep 5
      nano /var/www/$site_owner/tmp/${edited_site}.crt

      echo "Enter bundle after 5 seconds and save it..."
      sleep 5
      nano /var/www/$site_owner/tmp/${edited_site}.bundle
      echo "Enter private key after 5 seconds and save it..."
      sleep 5
      nano /var/www/$site_owner/tmp/${edited_site}.key

      cat /var/www/$site_owner/tmp/${edited_site}.crt /var/www/$site_owner/tmp/${edited_site}.bundle > /etc/nginx/ssl_certificates/${site_owner}/${edited_site}.chained.crt
      cat /var/www/$site_owner/tmp/${edited_site}.key > /etc/nginx/ssl_certificates/${site_owner}/${edited_site}.key

      rm -f /var/www/$site_owner/tmp/${edited_site}.crt /var/www/$site_owner/tmp/${edited_site}.bundle /var/www/$site_owner/tmp/${edited_site}.key
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
  
  used_template=`cat /usr/local/panel/src/conf_templates/nginx_ssl.template`
  eval "echo \"$used_template\"" > /etc/nginx/vhosts/$site_owner/$edited_site
  nginx -t > /dev/null 2>>$panel_log
  if [ $? = "1" ]
  then
    error_message="ERROR! Created conf does not valid. Check conf!"
    echo "\\t$error_message" | logging show
  else
    systemctl reload nginx > /dev/null 2>>$panel_log
  fi
 
  mysql_connector "UPDATE sites SET ssl_enable='y' WHERE name='$site_name';"

  message="OK! SSL for '$site_name' enabled!"
  echo "\\t$message" | logging show
  sleep 3

}


$action

exit 0
