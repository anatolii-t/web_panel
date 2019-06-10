#!/bin/bash
#--------VARIABLES START--------#
added_db_name=$1
logical_backup=$2
#--------VARIABLES END----------#


. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector

if [ "$check_permission_admin" = "1" ]
then
  if [ -z $3 ]
  then
    echo -e '\\tERROR! NOT ALL WARIABLES DEFINED!' | logging show
    echo -e 'Usage: add_new_dbsh db_name backup owner_name'
    exit 1
  else
    owner_added_db=$3
else
  owner_added_db=$panel_user
fi



action_perfomed="add_db"

start_message="Start adding DB ${added_db_name}"
echo "\\t$start_message" | logging


#Checking existing DB in panel
datbase_in_panel_is_exist=`mysql_connector "SELECT * FROM data_bases WHERE name='$added_db_name'" | wc -l`
if [ $database_in_panel_is_exist -gt 0 ]
then
  message="ERROR! DB '$added_db_name' already added in panel! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

#Checking existing DB in system
database_in_system_is_exist=`mysql -Bse "show databases;" | grep ^${added_db_name}$ | wc -l`
if [ $database_in_system_is_exist -gt 0 ]
then
  message="ERROR! DB '$added_db_name' already added in system! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

mysql_connector "INSERT INTO data_bases VALUES ('${added_db_name}', '${owner_added_db}', '${owner_added_db}', '${logical_backup}')"

mysql -e "create database ${added_db_name}"
mysql -e "grant all privileges on ${added_db_name}.* to '${owner_added_db}'@'localhost';"
mysql -e "flush privileges;"


message="OK! DB '$added_db_name' successfully created!" 
echo "\\t$message" | logging show
sleep 3

exit 0
