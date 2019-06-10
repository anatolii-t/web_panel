#!/bin/bash

trap 'exec $HOME/.panel/db/admin_dbs_category.sh' SIGINT

echo -en "\ec"

echo -e "\t\t\tDeleting DB user\n"


#Enter DB user name
while true
do

  read -p "Enter name DB user for delete: " entered_name_deleting_user

  #Turn user into lower case
  entered_name_deleting_user=$(echo $entered_name_deleting_user | tr '[:upper:]' '[:lower:]')

  #Check symbols in db name
  if echo $entered_name_deleting_user | grep -q "[^a-z0-9_]"
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/db/admin_dbs_category.sh
    else
      echo 'You enter DB name user with wrong characters. Allowed characters is a-Z , 0-9, and symbol _' 
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
break
done

sudo /usr/local/panel/bin/delete_db_user.sh $entered_name_deleting_user
$HOME/.panel/db/admin_dbs_category.sh
