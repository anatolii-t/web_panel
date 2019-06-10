#!/bin/bash

###---Script for listing WWW domain properties---###

. /usr/local/panel/bin/mysql_connector
. /usr/local/panel/bin/check_user
start_function=$1
entered_name_edited_site=$2


function short {
  mysql_connector "SELECT * FROM sites WHERE name='$entered_name_edited_site'"
}

function full {
  if [ `mysql_connector "SELECT * FROM sites WHERE name='$entered_name_edited_site'" | wc -l` = "0" ]
  then
    exit 1
  else
    mysql_connector_full "SELECT * FROM sites WHERE name='$entered_name_edited_site'"
  fi 
}

function full_user {
  if [ `mysql_connector "SELECT * FROM sites WHERE name='$entered_name_edited_site' AND owner='$panel_user'" | wc -l` = "0" ]
  then
    exit 1
  else
    mysql_connector_full "SELECT name, php_version, ssl_enable, backup FROM sites WHERE name='$entered_name_edited_site'"
  fi  
}


$start_function $entered_name_edited_site
