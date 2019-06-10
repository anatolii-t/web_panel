#!/bin/bash

trap 'exec $HOME/.panel/account/root_accounts_category.sh' SIGINT

echo -en "\ec"

echo -e "\t\t\tAdding new user\n"

wrong_count=0

#Enter user name
while true
do
  read -p "Enter name new admin: " entered_name_new_admin

  #Turn user into lower case
  entered_name_new_admin=$(echo $entered_name_new_admin | tr '[:upper:]' '[:lower:]')

  #Check symbols in user
  if echo $entered_name_new_admin | grep -q "[^a-z0-9_.-]"
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/account/root_accounts_category.sh
    else
      echo 'You enter admin name with wrong characters. Allowed characters is a-Z , 0-9 and symbols _.-'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0

  #check user lenght
  if [ `echo $entered_name_new_admin | wc -c` -ge "18" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/account/root_accounts_category.sh
    else
      echo 'You enter too long admin name. Allowed lenght of user name - maximum 16 symbols.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  if [ `echo $entered_name_new_admin | wc -c` -le "1" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/account/root_accounts_category.sh
    else
      echo 'You enter too short admin name. Allowed lenght of user name - minimum 1 symbol.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0

  #check symbols in one-symbols user name
  if [ `echo $entered_name_new_admin | wc -c` -eq "2" ] && ([ $entered_name_new_admin = "." ] || [ $entered_name_new_admin = "-" ] || [ $entered_name_new_admin = "_" ])
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/account/root_accounts_category.sh
    else
      echo "Invalid admin name '$entered_name_new_admin'"
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  
  #check user name dont start '-'
  if [ `echo $entered_name_new_admin | awk -F "" '{print $1}'` = "-" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/account/root_accounts_category.sh
    else
      echo "Admin name cant start '-'"
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  break
done

sudo /usr/local/panel/bin/root/add_admins_account.sh $entered_name_new_admin
exec $HOME/.panel/account/root_accounts_category.sh
