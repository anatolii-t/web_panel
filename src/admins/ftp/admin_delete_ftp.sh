#!/bin/bash

echo -en "\ec"

echo -e "\t\t\tDeleting FTP user\n"

wrong_count=0

trap 'exec $HOME/.panel/ftp/admin_ftps_category.sh' SIGINT

#Enter ftp user name
while true
do
  read -p "Enter name new FTP user: " entered_name_deleting_ftp_user

  #Turn FTP user name into lower case
  entered_name_deleting_ftp_user=$(echo $entered_name_deleting_ftp_user | tr '[:upper:]' '[:lower:]')

  #Check symbols in FTP user name
  if echo $entered_name_deleting_ftp_user | grep -q "[^a-z0-9_.-]"
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/ftp/admin_ftps_category.sh
    else
      echo 'You enter FTP user name with wrong characters. Allowed characters is a-Z , 0-9 and symbols _.-'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0

break
done

sudo /usr/local/panel/bin/delete_ftp_user.sh $entered_name_deleting_ftp_user
exec $HOME/.panel/ftp/admin_ftps_category.sh
