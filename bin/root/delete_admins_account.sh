#!/bin/bash

deleted_admin=$1

trap '' SIGINT

. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector

if [ "$panel_user" = "root" ]
then
  if [ -z $1]
  then
    echo "ERROR! Name admin for delete not set. Usage delete_admins_account.sh 'name_deleted_admin'"
  fi
  action_perfomed='delete_admin'
  start_message="Deleting admin $deleted_admin"
  echo "\\t$start_message" | logging

  #Checking existing admin in database
  admin_in_database_is_exist=`mysql_connector "SELECT * FROM admins WHERE name='$deleted_admin'" | wc -l`
  if [ $admin_in_database_is_exist -eq 0 ]
  then
    message="ERROR! Admin '$deleted_admin' does not exist in panel! Exiting now!"
    echo "\\t$message" | logging show
    sleep 3
    exit 1
  fi
  #Check admin is exist in system
  admin_in_system_is_exist=`id $deleted_admin 2>>$panel_log | grep '10(wheel)' | wc -l`
  if [ $admin_in_system_is_exist -eq 0 ]
  then
    message="ERROR! Admin '$deleted_admin' does not exist in system! Exiting now!"
    echo "\\t$message" | logging show
    sleep 3
    exit 1
  fi
  #Check existing dir
  if ! [ -d /home/admins/$deleted_admin ]  
  then
    message="ERROR! Directory for '$deleted_admin' does not exist! Exiting now!"
    echo "\\t$message" | logging show
    sleep 3
    exit 1
  fi
  
  killall -9 -u $deleted_admin
  userdel -r $deleted_admin 
  mysql_connector "DELETE FROM admins WHERE name='$deleted_admin'" 



  ok_message="OK! Admin $deleted_admin successfully deleted!"
  echo "\\t$ok_message" | logging show
  echo "Exiting after 5 seconds..."
  sleep 5
  exit 0
    
else
  echo "Permission denied!"
  exit 1
fi

