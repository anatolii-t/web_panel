#!/bin/bash
#!/bin/bash
deleted_user=$1

. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector

action_perfomed="delete_db"

#Checking existing user in database
user_in_database_is_exist=`mysql_connector "SELECT * FROM data_bases_users WHERE name='$deleted_user'" | wc -l`
if [ $user_in_database_is_exist -eq 0 ]
then
  message="ERROR! DB user '$deleted_user' not exist! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

#Checking existing user in system
user_in_system_is_exist=`mysql_connector "SELECT user FROM mysql.user WHERE user='$deleted_user'" | wc -l`
if [ $user_in_system_is_exist -eq 0 ]
then
  message="ERROR! User '$deleted_user' not exist! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

db_owner=`mysql_connector "select owner from data_bases_users where name='$deleted_user';"`
#check owner
if [ "$check_permission_admin" != "1" ] 
then
    if [ "$db_owner" != "$panel_user" ]
  then
  message="ERROR! DB user '$deleted_user' not belong to you! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1 
  fi
fi
if [ "$db_owner" == "$deleted_user" ]
then
  message="ERROR! Owner-user '$deleted_user' can not be deleted! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1 
fi

#Delete grants for user
mysql -e "revoke all privileges on *.* from '${deleted_user}'@'localhost';"
mysql -e "flush privileges;"

mysql_connector "DELETE FROM data_bases_users WHERE name='$deleted_user'" > /dev/null 2>>$panel_log

mysql -Bse "DROP USER '$deleted_user'@'localhost';"

#delete_user_from_db
db_with_user=`mysql_connector "SELECT name FROM data_bases WHERE users LIKE '%, $deleted_user,%' OR users LIKE '%, $deleted_user';"`
for i in $db_with_user
do
  mysql_connector "UPDATE data_bases SET users=REPLACE(users,', $deleted_user','') WHERE name='$i';"
done

message="OK! DB '$deleted_user' successfully deleted!"
echo "\\t$message" | logging show
sleep 3

exit 0

