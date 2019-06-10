#!/bin/bash
#--------VARIABLES START--------#
site_name=$1
#--------VARIABLES END----------#

. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector


action_perfomed="delete_site"
start_message="Start deleting site ${site_name}"
echo "\\t$start_message" | logging



#Check variables
if [ -z $1 ] 
then
  echo -e '\\tERROR! NOT ALL WARIABLES DEFINED!' | logging show
  echo -e 'Usage: delete_site.sh site_name'
  exit 1
fi

#check site in panel 
site_in_panel_exist=`mysql_connector "SELECT * FROM sites WHERE name='$site_name'" | wc -l`
if [ $site_in_panel_exist = "0" ]
then
  error_message="ERROR! Site $site_name dont found in panel!"
  echo "\\t$error_message" | logging show
  echo "Exiting after 5 seconds..."
  sleep 5
  exit 1
fi

site_owner=`mysql_connector "SELECT owner FROM sites WHERE name='$site_name'"`

#check owner
if [ "$check_permission_admin" != "1" ] && [ $panel_user != "root" ]
then
  if [ "$SUDO_USER" != "$panel_user" ] || [ "$SUDO_USER" != "$site_owner" ]
  then
    echo "Permission denied!" | logging show
    sleep 3
    exit 1
  fi
fi 

#check existing conf files Nginx
if [ -f /etc/nginx/vhosts/$site_owner/$site_name ]
then
  rm -rf /etc/nginx/vhosts/$site_owner/$site_name
else
  warning_message="Warning! Nginx config for $site_name dont found."   
  echo "\\t$error_message" | logging show
fi

  
#check existing conf files Apache
if [ -f /etc/httpd/vhosts/$site_owner/$site_name ]
then
  rm -rf /etc/httpd/vhosts/$site_owner/$site_name
else
  warning_message="Warning! Apache config for $site_name dont found."
  echo "\\t$error_message" | logging show
fi


#check existing site dir
if [ -d /var/www/$site_owner/www/$site_name ]
then
  rm -rf /var/www/$site_owner/www/$site_name
else
  warning_message="Warning! Dir for $site_name dont found."
  echo "\\t$error_message" | logging show
fi  

if [ -d /backup/users/$site_owner/www/$site_name ]
then
  rm -rf /backup/users/$site_owner/www/$site_name
fi

rm -rf /var/www/$site_owner/logs/nginx/${site_name}*

rm -rf /var/www/$site_owner/logs/httpd/${site_name}*

rm -rf /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf
  
#Deleting database record
mysql_connector "DELETE FROM sites WHERE name='$site_name'" > /dev/null 2>>$panel_log

message="OK! Site '$site_name' successfully deleted!"
echo "\\t$message" | logging show
sleep 3

exit 0
