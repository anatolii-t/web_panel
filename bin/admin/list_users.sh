#!/bin/bash

###---Script for list users---###

. /usr/local/panel/bin/mysql_connector
. /usr/local/panel/bin/check_user

if [ "$check_permission_admin" = "1" ] || [ $panel_user="root" ]
then
  echo -e "\t\t\tList all users"
  if [ `mysql_connector_full "SELECT * FROM users" | wc -l` = "0" ]
  then
    echo "---There are no users added in panel---"
  else
    mysql_connector_full "SELECT * FROM users"
  fi
else
  echo "Permission denied!"
  exit 1
fi
