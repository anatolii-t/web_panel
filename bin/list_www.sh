#!/bin/bash

###---Script for listing www domains---###

. /usr/local/panel/bin/mysql_connector
. /usr/local/panel/bin/check_user

if [ "$check_permission_admin" = "1" ] || [ $panel_user="root" ]
then
  echo -e "\t\t\tList all WWW domains"
  if [ `mysql_connector_full "SELECT * FROM sites" | wc -l` = "0" ]
  then
    echo "---There are no sites added in panel---"
  else
    mysql_connector_full "SELECT * FROM sites"
  fi
else
  echo -e "\t\t\tList WWW domains"
  if [ `mysql_connector_full "SELECT * FROM sites WHERE owner='$panel_user'" | wc -l` = "0" ]
  then
    echo "---There are no sites added in panel---"
  else
    mysql_connector_full "SELECT name, php_version, ssl_enable, backup FROM sites WHERE owner='$panel_user'"
  fi
fi
