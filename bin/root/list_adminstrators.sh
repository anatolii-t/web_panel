#!/bin/bash

###---Script for list users---###

. /usr/local/panel/bin/mysql_connector
. /usr/local/panel/bin/check_user

if [ $panel_user="root" ]
then
  echo -e "\t\t\tList all admins"
  if [ `mysql_connector_full "SELECT * FROM admins" | wc -l` = "0" ]
  then
    echo "---There are no admins added in panel---"
  else
    mysql_connector_full "SELECT * FROM admins"
  fi
else
  echo "Permission denied!"
  exit 1
fi
