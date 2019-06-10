#!/bin/bash
#--------VARIABLES START--------#
deleted_user_name=$1
#--------VARIABLES END----------#


. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector

if [ "$check_permission_admin" != "1" ] && [ $panel_user != "root" ]
then
  echo "Permission denied!"
  sleep 3
  exit 1
fi


action_perfomed="delete_user"

start_message="Start deleting user ${deleted_user_name}"
echo "\\t$start_message" | logging

#Checking existing admin in database
user_in_database_is_exist=`mysql_connector "SELECT * FROM users WHERE name='$deleted_user_name'" | wc -l`
if [ $user_in_database_is_exist -eq 0 ]
then
  message="ERROR! User '$deleted_user_name' does not exist in panel! Exiting now!"
  echo "\\t$message" | logging show
  sleep 3
  exit 1
fi
#Check admin is exist in system
user_in_system_is_exist=`id $deleted_user_name 2>>$panel_log | grep 'panel_users' | wc -l`
if [ $user_in_system_is_exist -eq 0 ]
then
  message="ERROR! User '$deleted_user_name' does not exist in system! Exiting now!"
  echo "\\t$message" | logging show
  sleep 3
  exit 1
fi
#Check existing dir
if ! [ -d /var/www/$deleted_user_name ]
then
  message="ERROR! Directory for '$deleted_user_name' does not exist! Exiting now!"
  echo "\\t$message" | logging show
  sleep 3
  exit 1
fi


#Delete user
mysql_connector "DELETE FROM users WHERE name='$deleted_user_name'" > /dev/null 2>>$panel_log
#Delete sites
mysql_connector "DELETE FROM sites WHERE owner='$deleted_user_name'" > /dev/null 2>>$panel_log
#DeleteDB user and databases
list_db_deleted_user=`mysql_connector "SELECT name FROM data_bases WHERE owner='$deleted_user_name'"`
for i in $list_db_deleted_user
do
  mysql_connector "DROP DATABASE '$i'"
done
mysql_connector "DELETE FROM data_bases WHERE owner='$deleted_user_name'" > /dev/null 2>>$panel_log

list_db_users_deleted_user=`"SELECT name FROM data_bases_users WHERE owner='$deleted_user_name'"`
for i in $list_db_deleted_user
do
  mysql_connector "DROP USER '$i'@'localhost'"
done
mysql_connector "DROP USER '$deleted_user_name'@'localhost'"
mysql_connector "FLUSH PRIVILEGES;"
mysql_connector "DELETE FROM data_bases_users WHERE owner='$deleted_user_name'" > /dev/null 2>>$panel_log

#Delete FTP-users
ftp_users_deleted_user=`mysql_connector "SELECT name FROM ftp_users WHERE owner='$deleted_user_name'"`
for i in $ftp_users_deleted_user
do
  ftpasswd --passwd --file=/etc/ftpd.passwd --name=$i --delete-user
done
mysql_connector "DELETE FROM ftp_users WHERE owner='$deleted_user_name'" > /dev/null 2>>$panel_log



rm -rf /etc/httpd/vhosts/$deleted_user_name > /dev/null 2>>$panel_log
rm -rf /etc/nginx/vhosts/$deleted_user_name > /dev/null 2>>$panel_log
rm -rf /backup/users/$deleted_user_name > /dev/null 2>>$panel_log

killall -9 -u $deleted_user_name
userdel -r $deleted_user_name

ok_message="OK! User $deleted_admin successfully deleted!"
echo "\\t$ok_message" | logging show
echo "Exiting after 5 seconds..."
sleep 5
exit 0


