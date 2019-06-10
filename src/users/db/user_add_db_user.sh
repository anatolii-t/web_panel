#!/bin/bash

trap 'exec $HOME/.panel/db/user_dbs_category.sh' SIGINT

echo -en "\ec"

echo -e "\t\t\tAdding new DB user\n"

#Enter DB user name
while true
do

  read -p "Enter name new DB user: " entered_name_new_db_user

  #Turn user into lower case
  entered_name_new_db_user=$(echo $entered_name_new_db_user | tr '[:upper:]' '[:lower:]')
  
  #Check symbols in db name
  if echo $entered_name_new_db_user | grep -q "[^a-z0-9_]"
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

  #check db name lenght
  if [ `echo $entered_name_new_db_user | wc -c` -ge "18" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/db/user_dbs_category.sh
    else
      echo 'You enter too long DB user name. Allowed lenght of DB name - maximum 64 symbols.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  if [ `echo $entered_name_new_db_user | wc -c` -le "1" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/db/user_dbs_category.sh
    else
      echo 'You enter too short DB user name. Allowed lenght of user name - minimum 1 symbol.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  #check symbols in one-symbols DB name
  if [ `echo $entered_name_new_db_user | wc -c` -eq "2" ] && [ $entered_name_new_db_user = "_" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/db/user_dbs_category.sh
    else
      echo "Invalid DB user name '$entered_name_new_db_user'"
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  break
done


sudo /usr/local/panel/bin/add_new_db_user.sh $entered_name_new_db_user
exec $HOME/.panel/db/user_dbs_category.sh
