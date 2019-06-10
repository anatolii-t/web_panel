#!/bin/bash

trap 'exec $HOME/.panel/account/root_accounts_category.sh' SIGINT

echo -en "\ec"

echo -e "\t\t\tDeleting user\n"

wrong_count=0

#Enter user name
while true
do
  read -p "Enter name admin that deleting: " entered_name_deleting_admin

  #Turn user into lower case
  entered_name_deleting_admin=$(echo $entered_name_deleting_admin | tr '[:upper:]' '[:lower:]')

  #Check symbols in user
  if echo $entered_name_deleting_admin | grep -q "[^a-z0-9_.-]"
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/account/root_accounts_category.sh
    else
      echo 'You enter user admin with wrong characters. Allowed characters is a-Z , 0-9 and symbols _.-'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
done

sudo /usr/local/panel/bin/root/delete_admins_account.sh "$entered_name_deleting_admin"
exec $HOME/.panel/account/root_accounts_category.sh
