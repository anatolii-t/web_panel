#!/bin/bash

trap 'exec $HOME/.panel/account/admin_accounts_category.sh' SIGINT

echo -en "\ec"

echo -e "\t\t\tDeleting user\n"

wrong_count=0

#Enter user name
while true
do
  read -p "Enter name user that deleting: " entered_name_deleting_user

  #Turn user into lower case
  entered_name_deleting_user=$(echo $entered_name_deleting_user | tr '[:upper:]' '[:lower:]')

  #Check symbols in user
  if echo $entered_name_deleting_user | grep -q "[^a-z0-9_.-]"
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/account/admin_accounts_category.sh
    else
      echo 'You enter user name with wrong characters. Allowed characters is a-Z , 0-9 and symbols _.-'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
done

sudo /usr/local/panel/bin/admin/delete_users_account "$entered_name_deleting_user"
exec $HOME/.panel/account/admin_accounts_category.sh
