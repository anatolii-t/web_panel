#!/bin/bash

name_ftp_user=$1
full_path=$2 

. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector

action_perfomed="add_ftp_user"


start_message="Start adding ftp user ${name_ftp_user} "
echo "\\t$start_message" | logging


if [ "$check_permission_admin" = "1" ]
then
  if [ -z $3 ]
  then
    echo -e '\\tERROR! NOT ALL WARIABLES DEFINED!' | logging show
    echo -e 'Usage: add_new_ftp_user.sh user_name full_path owner'
    exit 1
  fi
  entered_owner_ftp_user=$3
else
  entered_owner_ftp_user=$panel_user
fi


#Check user in system
ftp_user_in_system=`cat /etc/ftpd.passwd | awk -F ":" '{print $1}' | grep "^${name_ftp_user}$" | wc -l`
if [ $ftp_user_in_system = "1" ] 
then
  error_message="ERROR! FTP-user $name_ftp_user already exist in system!"
  echo "\\t$error_message" | logging show
  echo "Exiting after 5 seconds..."
  sleep 5
  exit 1
fi
#Check user in panel
ftp_user_in_panel=`mysql_connector "SELECT * FROM ftp_users WHERE name='$name_ftp_user'" | wc -l`
if [ $ftp_user_in_panel = "1" ]
then
  error_message="ERROR! FTP-user $name_ftp_user already exist in system!"
  echo "\\t$error_message" | logging show
  echo "Exiting after 5 seconds..."
  sleep 5
  exit 1
fi



#Add user


user_id=`id -u $entered_owner_ftp_user`
echo $ftp_pass | ftpasswd --stdin --passwd --name $name_ftp_user --uid $user_id --home $full_path --shell /bin/false --file /etc/ftpd.passwd

mysql_connector "INSERT INTO ftp_users VALUES ('${name_ftp_user}', '${entered_owner_ftp_user}', '${full_path}')"

message="OK! FTP User '$name_ftp_user' successfully created!"
echo "\\t$message" | logging show
sleep 3
exit 0
