#!/bin/bash

edited_site=$1
action=$2


. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector

action_perfomed="edit_backup_status_site"

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

check_current_status=`mysql_connector "SELECT backup FROM sites WHERE name='$edited_site'"`
if [ "$check_current_status" == "n" ]
then
  if [ "$action" == "disable_backup" ]
  then
    message="ERROR! Backup for site '$edited_site' already disabled! Exiting now!"
    echo "\\t$message" | logging show
    sleep 5
    exit 1
  fi
else
  if [ "$action" == "enable_backup" ]
  then
    message="ERROR! Backup for site '$edited_site' already enabled! Exiting now!"
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
function disable_backup {
 
  mysql_connector "UPDATE sites SET backup='n' WHERE name='$site_name';"

  message="OK! Backup for '$site_name' disabled!"
  echo "\\t$message" | logging show
  sleep 3
}



function enable_backup {
  
  mysql_connector "UPDATE sites SET backup='y' WHERE name='$site_name';"  

  message="OK! Backup for '$site_name' enabled!"
  echo "\\t$message" | logging show
  sleep 3

}

$action

exit 0
