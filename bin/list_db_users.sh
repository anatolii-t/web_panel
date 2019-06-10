#!/bin/bash

###---Script for listing database users---###

. /usr/local/panel/bin/mysql_connector
. /usr/local/panel/bin/check_user

if [ "$check_permission_admin" = "1" ] || [ "$panel_user" = "root" ]
then
  echo -e "\t\t\tList all DB users"
  if [ `mysql_connector_full "SELECT * FROM data_bases_users" | wc -l` = "0" ]
  then
    echo "---There are no DB users added in panel---"
  else
    mysql_connector_full "SELECT * FROM data_bases_users"
  fi
else
  echo -e "\t\t\tList DB users"
  if [ `mysql_connector_full "SELECT * FROM data_bases_users WHERE owner='$panel_user'" | wc -l` = "0" ]
  then
    echo "---There are no sites added in panel---"
  else
    mysql_connector_full "SELECT name FROM data_bases_users WHERE owner='$panel_user'"
  fi
fi
