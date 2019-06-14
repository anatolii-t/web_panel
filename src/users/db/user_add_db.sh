#!/bin/bash

echo -en "\ec"

echo -e "\t\t\tAdding new DB\n"

wrong_count=0

trap 'exec $HOME/.panel/db/user_dbs_category.sh' SIGINT


#Enter user name
while true
do
  read -p "Enter name new DB: " entered_name_new_db

  #Turn user into lower case
  entered_name_new_db=$(echo $entered_name_new_db | tr '[:upper:]' '[:lower:]')

  #Check symbols in db name
  if echo $entered_name_new_db | grep -q "[^a-z0-9_]"
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

  #check db name lenght
  if [ `echo $entered_name_new_db | wc -c` -ge "66" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/db/user_dbs_category.sh
    else
      echo 'You enter too long DB name. Allowed lenght of DB name - maximum 64 symbols.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  if [ `echo $entered_name_new_db | wc -c` -le "1" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/db/user_dbs_category.sh
    else
      echo 'You enter too short DB name. Allowed lenght of user name - minimum 1 symbol.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  #check symbols in one-symbols DB name
  if [ `echo $entered_name_new_db | wc -c` -eq "2" ] && [ $entered_name_new_db = "_" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/db/user_dbs_category.sh
    else
      echo "Invalid DB name '$entered_name_new_db'"
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  break
done

#Enable/dont backup
while true
do
  read -p "Enable backup for new DB? (yes/no): " enabling_backup_new_db
  case "$enabling_backup_new_db" in
      "yes" ) backup_new_db="y";;
      "no" ) backup_new_db="n";;
      * ) if [ $wrong_count = "2" ]
          then
            echo 'ERROR! You entered wrong argument 3 times. Return to the previous menu after 5 seconds...'
            sleep 5
            exec $HOME/.panel/db/user_dbs_category.sh
          else
            echo 'Pleas type "yes" or "no"' 
            wrong_count=$[ $wrong_count + 1 ]
            continue
          fi;;
  esac
  wrong_count=0
  break
done


sudo /usr/local/panel/bin/add_new_db.sh $entered_name_new_db $backup_new_db $entered_owner_new_db
exec $HOME/.panel/db/user_dbs_category.sh
