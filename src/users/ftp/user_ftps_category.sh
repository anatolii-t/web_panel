#!/bin/bash

while true
do

  #Clear screen 
  echo -en "\ec"

  if [ ! -z "$ERROR_MESSAGE" ]
  then
    echo -e "\n${ERROR_MESSAGE}\n"
  fi


  echo -e "\t\t\tFTP ACCOUNTS\n"   

  sudo /usr/local/panel/bin/list_ftp_users.sh


  echo -e "
  Available function:
  \t\t\t1. Add new FTP-account
  \t\t\t2. Delete FTP-account
  \t\t\t3. Return to previous menu\n\n"

  wrong_count=0

  while true
  do
    read -p "Enter number of needed function: " choosen_function
    case "$choosen_function" in
      "1" ) exec $HOME/.panel/ftp/user_add_ftp.sh;;
      "2" ) exec $HOME/.panel/ftp/user_delete_ftp.sh;;
      "6" ) exec $HOME/.panel/user_panel_start.sh;;
      * ) if [ $wrong_count = "2" ]
          then
            ERROR_MESSAGE='ERROR! You entered wrong argument 3 times. Return to the previous menu'
            break
          else
            echo "Wrong argument. Try again." 
            wrong_count=$[ $wrong_count + 1 ]
          fi
      ;;
    esac
  done
done
