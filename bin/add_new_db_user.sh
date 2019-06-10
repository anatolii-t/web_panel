#!/bin/bash
#--------VARIABLES START--------#
added_db_user_name=$1
#--------VARIABLES END----------#


. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector

if [ "$check_permission_admin" = "1" ]
then
  if [ -z $2 ]
  then
    echo -e '\\tERROR! NOT ALL WARIABLES DEFINED!' | logging show
    echo -e 'Usage: add_new_db_user.sh db_user_name owner_name'
    exit 1
  else
    owner_added_db_user=$2
else
  owner_added_db_user=$panel_user
fi



action_perfomed="add_db_user"

start_message="Start adding DB user ${added_db_user_name}"
echo "\\t$start_message" | logging


#Checking existing user in database
user_in_database_is_exist=`mysql_connector "SELECT * FROM data_bases_users WHERE name='$added_db_user_name'" | wc -l`
if [ $user_in_database_is_exist -gt 0 ]
then
  message="ERROR! DB user '$added_db_user_name' already added in panel! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

#Checking existing user in system
user_in_system_is_exist=`mysql_connector "SELECT user FROM mysql.user WHERE user='$added_db_user_name'" | wc -l`
if [ $user_in_system_is_exist -gt 0 ]
then
  message="ERROR! User '$added_db_user_name' already added in system! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

mysql_user_password=`pwgen -cns -N 1 21`
mysql -e "CREATE USER '$added_db_user_name'@'localhost' IDENTIFIED BY '$mysql_user_password'"
echo "Setted password for user: $mysql_user_password"
sleep 15

mysql_connector "INSERT INTO data_bases_users VALUES ('${added_db_user_name}', '${owner_added_db_user}')"

message="OK! DB user '$added_db_user_name' successfully created!" 
echo "\\t$message" | logging show
sleep 3
exit 0
