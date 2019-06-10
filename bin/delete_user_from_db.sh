#!/bin/bash
neeaded_db=$1
neeaded_user=$2

. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector

action_perfomed="delete_user_from_db"


start_message="Start deleting user ${neeaded_user} from DB ${neeaded_db}"
echo "\\t$start_message" | logging


#Checking existing DB in panel
datbase_in_panel_is_exist=`mysql_connector "SELECT * FROM data_bases WHERE name='$neeaded_db'" | wc -l`
if [ $database_in_panel_is_exist -eq 0 ]
then
  message="ERROR! DB '$neeaded_db' not exist! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

#Checking existing DB in system
database_in_system_is_exist=`mysql -Bse "show databases;" | grep ^${neeaded_db}$ | wc -l`
if [ $database_in_system_is_exist -eq 0 ]
then
  message="ERROR! DB '$neeaded_db' not exist! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

#Checking existing user in database
user_in_database_is_exist=`mysql_connector "SELECT * FROM data_bases_users WHERE name='$neeaded_user'" | wc -l`
if [ $user_in_database_is_exist -eq 0 ]
then
  message="ERROR! DB user '$neeaded_user' not exist! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

#Checking existing user in system
user_in_system_is_exist=`mysql_connector "SELECT user FROM mysql.user WHERE user='$neeaded_user'" | wc -l`
if [ $user_in_system_is_exist -eq 0 ]
then
  message="ERROR! User '$neeaded_user' not exist! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

#check_user_added_in_db
user_in_system_is_exist=`mysql_connector "SELECT users FROM data_bases WHERE name='neeaded_db'" | grep ", $neeaded_user," | wc -l`
if [ $user_in_system_is_exist -eq 0 ]
then
  message="ERROR! User '$neeaded_user' not added in DB '$neeaded_db'! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi



owner_db=`mysql_connector "SELECT owner FROM data_bases WHERE name='$neeaded_db'"`
owner_user=`mysql_connector "SELECT owner FROM data_bases_users WHERE name='$neeaded_user'"`

if [ "$check_permission_admin" = "1" ] || [ $panel_user = "root" ]
then
  if [ "$owner_db" != "$owner_user" ]
  then
    message="ERROR! Owner DB and owner DB user's values missmatch! Exiting now!"
    echo "\\t$message" | logging show
    sleep 5
    exit 1
  fi
else
  if [ "$owner_db" != "$panel_user" ] || [ "$owner_user" != "$panel_user" ]
  then
    message="ERROR! Owner DB or owner DB user's dont belong to you! Exiting now!"
    echo "\\t$message" | logging show
    sleep 5
    exit 1
  fi
fi

mysql_connector "UPDATE data_bases SET users=REPLACE(users,', $neeaded_user','') WHERE name='$neeaded_db';"

mysql -e "revoke all privileges on ${neeaded_db}.* from '${neeaded_user}'@'localhost';"
mysql -e "flush privileges;"

message="OK! DB user '$neeaded_user' successfully added in DB '$neeaded_db'!"
echo "\\t$message" | logging show
sleep 3
exit 0
