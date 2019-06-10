#!/bin/bash

echo -en "\ec"

echo -e "\t\t\tAdding DB user in DB\n"

wrong_count=0

trap 'exec $HOME/.panel/db/user_dbs_category.sh' SIGINT


#Enter user name
while true
do
  read -p "Enter name DB in which need to add user: " entered_name_db_for_add_user

  #Turn user into lower case
  entered_name_db_for_add_user=$(echo $entered_name_db_for_add_user | tr '[:upper:]' '[:lower:]')

  #Check symbols in db name
  if echo $entered_name_db_for_add_user | grep -q "[^a-z0-9_]"
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/db/user_dbs_category.sh
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

  read -p "Enter name user which need add in DB: " entered_name_user_for_add_in_db

  #Turn user into lower case
  entered_name_user_for_add_in_db=$(echo $entered_name_user_for_add_in_db | tr '[:upper:]' '[:lower:]')

  #Check symbols in db name
  if echo $entered_name_user_for_add_in_db | grep -q "[^a-z0-9_]"
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/db/user_dbs_category.sh
    else
      echo 'You enter DB name user with wrong characters. Allowed characters is a-Z , 0-9, and symbol _' 
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
break 
done

sudo /usr/local/panel/bin/add_user_in_db.sh $entered_name_db_for_add_user $entered_name_user_for_add_in_db 
exec $HOME/.panel/db/user_dbs_category.sh
