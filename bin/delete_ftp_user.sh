#!/bin/bash

name_ftp_user=$1

. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector

action_perfomed="delete_ftp_user"


start_message="Start delete ftp user ${name_ftp_user} "
echo "\\t$start_message" | logging


if [ "$check_permission_admin" != "1" ]
then
  owner_ftp_user=`mysql_connector "SELECT owner FROM ftp_users WHERE name='$name_ftp_user'"`
  if [ "$owner_ftp_user" != "$panel_user" ]
  then
    message="ERROR! FTP user '$name_ftp_user' not belong to you! Exiting now!"
    echo "\\t$message" | logging show
    sleep 5
    exit 1
  fi
fi


#Check user in system
ftp_user_in_system=`cat /etc/ftpd.passwd | awk -F ":" '{print $1}' | grep "^${name_ftp_user}$" | wc -l`
if [ $ftp_user_in_system != "1" ] 
then
  error_message="ERROR! FTP-user $name_ftp_user dont exist in system!"
  echo "\\t$error_message" | logging show
  echo "Exiting after 5 seconds..."
  sleep 5
  exit 1
fi
#Check user in panel
ftp_user_in_panel=`mysql_connector "SELECT * FROM ftp_users WHERE name='$name_ftp_user'" | wc -l`
if [ $ftp_user_in_panel != "1" ]
then
  error_message="ERROR! FTP-user $name_ftp_user dont exist in system!"
  echo "\\t$error_message" | logging show
  echo "Exiting after 5 seconds..."
  sleep 5
  exit 1
fi



#Delete user

ftpasswd --passwd --name $name_ftp_user --file /etc/ftpd.passwd --delete-user

mysql_connector "DELETE FROM ftp_users WHERE name='${name_ftp_user}'"

message="OK! FTP User '$name_ftp_user' successfully deleted!"
echo "\\t$message" | logging show
sleep 3
exit 0
