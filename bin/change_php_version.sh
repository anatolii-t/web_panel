#!/bin/bash
#--------VARIABLES START--------#
site_name=$1
#--------VARIABLES END----------#

. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector

action_perfomed="change_php_version"

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

#check existing conf files Apache
if [ ! -f /etc/httpd/vhosts/$site_owner/$site_name ]
then
  warning_message="Warning! Apache config for $site_name dont found."
  echo "\\t$error_message" | logging show
fi

if [ ! -f /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf ]
then
  error_message="ERROR! PHP config for $site_name dont found. Exiting!"
  echo "\\t$error_message" | logging show
  sleep 5
  exit 1
fi

current_version=`mysql_connector "SELECT php_version FROM sites WHERE name='$site_name'"`

while true
do
  echo -e "Available versions:\n"
  cat /usr/local/panel/var/php_versions
  read -p "Enter new neaded php version for new site: " new_php_version
  if [[ ! " ${php_versions[@]} " =~ " ${new_php_version} " ]]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exit 1
    else
      echo 'You enter wrong PHP versions. Try again.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  
  if [ "$current_version" == "$new_php_version" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exit 1
    else
      echo 'You enter same PHP versions. Try again.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  break
done


case "$new_php_version" in
  "5.6(Apache)") echo "" > /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf;;
  "5.4(CGI)") cat /etc/httpd/php_versions/php54.conf > /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf;;
  "5.5(CGI)") cat /etc/httpd/php_versions/php55.conf > /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf;;
  "5.6(CGI)") cat /etc/httpd/php_versions/php56.conf > /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf;;
  "7.0(CGI)") cat /etc/httpd/php_versions/php70.conf > /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf;;
  "7.1(CGI)") cat /etc/httpd/php_versions/php71.conf > /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf;;
  "7.2(CGI)") cat /etc/httpd/php_versions/php72.conf > /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf;;
  "7.3(CGI)") cat /etc/httpd/php_versions/php73.conf > /etc/httpd/vhosts_php/${site_owner}/${site_name}_php.conf;;
esac

mysql_connector "UPDATE sites SET php_version='$new_php_version' WHERE name='$site_name';"

message="OK! PHP version '$new_php_version' for '$site_name' setted!"
echo "\\t$message" | logging show
sleep 3


exit 0
