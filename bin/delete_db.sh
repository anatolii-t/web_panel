#!/bin/bash
#!/bin/bash
deleted_db=$1

. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector

action_perfomed="delete_db"

#Checking existing DB in panel
datbase_in_panel_is_exist=`mysql_connector "SELECT * FROM data_bases WHERE name='$deleted_db'" | wc -l`
if [ $database_in_panel_is_exist -eq 0 ]
then
  message="ERROR! DB '$deleted_db' not exist! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

#Checking existing DB in system
database_in_system_is_exist=`mysql -Bse "show databases;" | grep ^${deleted_db}$ | wc -l`
if [ $database_in_system_is_exist -eq 0 ]
then
  message="ERROR! DB '$deleted_db' not exist! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

#check owner
if [ "$check_permission_admin" != "1" ] 
then
  db_owner=`mysql_connector "select owner from data_bases where name='$deleted_db';"`
  if [ "$db_owner" != "$panel_user" ]
  then
   message="ERROR! DB '$deleted_db' not belong to you! Exiting now!"
   echo "\\t$message" | logging show
   sleep 5
   exit 
  fi
fi

#Delete grants for all DB users
for i in `mysql_connector "select users from data_bases where name='$deleted_db';" | awk -F ", " '{print $0}'` 
do 
  user_name=`echo $i | sed s/,//g`
  mysql -e "revoke all privileges on ${deleted_db}.* from '${user_name}'@'localhost';"
done

mysql_connector "DELETE FROM data_bases WHERE name='$deleted_db'" > /dev/null 2>>$panel_log

mysql -Bse "DROP DATABASE $deleted_db"

message="OK! DB '$deleted_db' successfully deleted!"
echo "\\t$message" | logging show
sleep 3

exit 0

