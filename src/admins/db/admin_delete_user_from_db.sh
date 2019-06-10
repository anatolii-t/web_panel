#!/bin/bash

echo -en "\ec"

echo -e "\t\t\tDelete DB user from DB\n"

wrong_count=0

trap 'exec $HOME/.panel/db/admin_dbs_category.sh' SIGINT


#Enter user name
while true
do
  read -p "Enter name DB in which need to delete user: " entered_name_db_from_delete_user

  #Turn user into lower case
  entered_name_db_from_delete_user=$(echo $entered_name_db_from_delete_user | tr '[:upper:]' '[:lower:]')

  #Check symbols in db name
  if echo $entered_name_db_from_delete_user | grep -q "[^a-z0-9_]"
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


#Enter DB user name
while true
do

  read -p "Enter name user which need delete from DB: " entered_name_user_for_delete_from_db

  #Turn user into lower case
  entered_name_user_for_delete_from_db=$(echo $entered_name_user_for_delete_from_db | tr '[:upper:]' '[:lower:]')

  #Check symbols in db name
  if echo $entered_name_user_for_delete_from_db | grep -q "[^a-z0-9_]"
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

sudo /usr/local/panel/bin/delete_user_from_db.sh $entered_name_db_from_delete_user $entered_name_user_for_delete_from_db 
exec $HOME/.panel/db/admin_dbs_category.sh
