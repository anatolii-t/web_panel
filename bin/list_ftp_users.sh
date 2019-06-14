#!/bin/bash

###---Script for listing FTP users---###

. /usr/local/panel/bin/mysql_connector
. /usr/local/panel/bin/check_user

if [ "$check_permission_admin" = "1" ] || [ "$panel_user" = "root" ]
then
  echo -e "\t\t\tList all FTP users"
  if [ `mysql_connector_full "SELECT * FROM ftp_users" | wc -l` = "0" ]
  then
    echo "---There are no FTP users added in panel---"
  else
    mysql_connector_full "SELECT * FROM ftp_users"
  fi
else
  echo -e "\t\t\tList FTP users"
  if [ `mysql_connector_full "SELECT * FROM ftp_users WHERE owner='$panel_user'" | wc -l` = "0" ]
  then
    echo "---There are no FTP users added in panel---"
  else
    mysql_connector_full "SELECT name, dir FROM ftp_users WHERE owner='$panel_user'"
  fi
fi
