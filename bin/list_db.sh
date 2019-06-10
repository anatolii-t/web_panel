#!/bin/bash

###---Script for listing DB---###

. /usr/local/panel/bin/mysql_connector
. /usr/local/panel/bin/check_user

if [ "$check_permission_admin" = "1" ] || [ $panel_user="root" ]
then
  echo -e "\t\t\tList all DB domains"
  if [ `mysql_connector_full "SELECT * FROM data_bases" | wc -l` = "0" ]
  then
    echo "---There are no databases added in panel---"
  else
    mysql_connector_full "SELECT * FROM data_bases"
  fi
else
  echo -e "\t\t\tList DB"
  if [ `mysql_connector_full "SELECT * FROM data_bases WHERE owner='$panel_user'" | wc -l` = "0" ]
  then
    echo "---There are no sites added in panel---"
  else
    mysql_connector_full "SELECT name, users FROM data_bases WHERE owner='$panel_user'"
  fi
fi

