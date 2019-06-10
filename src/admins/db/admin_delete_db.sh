#!/bin/bash

echo -en "\ec"

echo -e "\t\t\tDeleting DB\n"

wrong_count=0

trap 'exec $HOME/.panel/db/admin_dbs_category.sh' SIGINT


#Enter user name
while true
do
  read -p "Enter name DB for delete: " entered_name_db_for_delete

  #Turn user into lower case
  entered_name_db_for_delete=$(echo $entered_name_db_for_delete | tr '[:upper:]' '[:lower:]')

  #Check symbols in db name
  if echo $entered_name_db_for_delete | grep -q "[^a-z0-9_]"
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/db/admin_dbs_category.sh
    else
      echo 'You enter DB name with wrong characters. Allowed characters is a-Z , 0-9 and symbols _.-'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
break
done

sudo /usr/local/panel/bin/delete_db.sh $entered_name_db_for_delete
exec $HOME/.panel/db/admin_dbs_category.sh
