#!/bin/bash

echo -en "\ec"

echo -e "\t\t\tAdding new DB\n"

wrong_count=0

trap 'exec $HOME/.panel/ftp/root_ftps_category.sh' SIGINT

#Enter ftp user name
while true
do
  read -p "Enter name new FTP user: " entered_name_new_ftp_user

  #Turn FTP user name into lower case
  entered_name_new_ftp_user=$(echo $entered_name_new_ftp_user | tr '[:upper:]' '[:lower:]')

  #Check symbols in FTP user name
  if echo $entered_name_new_ftp_user | grep -q "[^a-z0-9_.-]"
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/ftp/root_ftps_category.sh
    else
      echo 'You enter FTP user name with wrong characters. Allowed characters is a-Z , 0-9 and symbols _.-'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0

  #check ftp user name lenght
  if [ `echo $entered_name_new_ftp_user | wc -c` -ge "66" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/ftp/root_ftps_category.sh
    else
      echo 'You enter too long FTP user name. Allowed lenght of FTP user name - maximum 64 symbols.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  if [ `echo $entered_name_new_ftp_user | wc -c` -le "1" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/ftp/root_ftps_category.sh
    else
      echo 'You enter too short FTP user name. Allowed lenght of FTP user name - minimum 1 symbol.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  #check symbols in one-symbols FTP user name
  if [ `echo $entered_name_new_ftp_user | wc -c` -eq "2" ] && ([ $entered_name_new_ftp_user = "_" ] || [ $entered_name_new_ftp_user = "-" ] || [ $entered_name_new_ftp_user = "." ])
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/ftp/root_ftps_category.sh
    else
      echo "Invalid FTP user name '$entered_name_new_ftp_user'"
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  break
done

while true
do
  read -p "Enter owner new FTP account: " entered_owner_new_ftp_account
  #Turn owner into lower case
  entered_owner_new_ftp_account=$(echo $entered_owner_new_ftp_account | tr '[:upper:]' '[:lower:]')  

  #Check symbols in owner
  if echo $entered_owner_new_ftp_account | grep -q "[^a-z0-9_.-]"
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/ftp/root_ftps_category.sh
    else
      echo 'You enter owner name with wrong characters. Allowed characters is a-Z , 0-9 and symbols _.-'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  break
done

while true
do
  echo "Type path for new FTP account"
  read -p "/var/www/$entered_owner_new_ftp_account/" entered_path_new_ftp_account
  #Turn path into lower case
  entered_path_new_ftp_account=$(echo $entered_path_new_ftp_account | tr '[:upper:]' '[:lower:]')

  #Check symbols in path
  if echo $entered_path_new_ftp_account | grep -q "[^/a-z0-9_.-]"
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/ftp/root_ftps_category.sh
    else
      echo 'You enter path with wrong characters. Allowed characters is a-Z , 0-9 and symbols /_.-'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  
  full_path_new_ftp_account="/var/www/$entered_owner_new_ftp_account/$entered_path_new_ftp_account"

  #check path lenght
  if [ `echo $full_path_new_ftp_account | wc -c` -ge "602" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/db/root_dbs_category.sh
    else
      echo 'You enter too long path. Allowed lenght of full path - maximum 600 symbols.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  if [ `echo $entered_path_new_ftp_account | wc -c` -le "1" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/db/root_dbs_category.sh
    else
      echo 'You enter too short path. Allowed lenght of path - minimum 1 symbol.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  #check symbols in one-symbols DB name
  if [ `echo $entered_path_new_ftp_account | wc -c` -eq "2" ] && [ $entered_path_new_ftp_account = "." ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/db/root_dbs_category.sh
    else
      echo "Invalid path '$entered_path_new_ftp_account'"
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  break
done


sudo /usr/local/panel/bin/add_new_ftp_user.sh $entered_name_new_ftp_user $full_path_new_ftp_account $entered_owner_new_ftp_account
exec $HOME/.panel/db/root_dbs_category.sh
