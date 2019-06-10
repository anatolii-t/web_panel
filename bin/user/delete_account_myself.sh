#!/bin/bash
runed_user=$1

. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector

action_perfomed="admin_self_delete"

start_message="Admin $runed_user deleting himself"
  echo "\\t$start_message" | logging


if [ "$runed_user" != "$SUDO_USER" ]
then
  echo "Permission denied!"
  sleep 3
  exit 1
fi

mysql_connector "DELETE FROM admins WHERE name='$runed_user'"

ok_message="OK! Admin $runed_user delete himself"
echo "\\t$ok_message" | logging show
sleep 5

userdel -r $runed_user
killall -9 -u $runed_user
exit 0
