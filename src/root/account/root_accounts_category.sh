#!/bin/bash
while true
do

  #Clear screen 
  echo -en "\ec"

  if [ ! -z "$ERROR_MESSAGE" ]
  then
    echo -e "\n${ERROR_MESSAGE}\n"
  fi

  echo -e "\t\t\tACCOUNTS\n" 
 
  sudo /usr/local/panel/bin/admin/list_users.sh


  echo -e "
  Available function:
  \t\t\t1. Add new user's account
  \t\t\t2. Delete user's account
  \t\t\t3. Add new admin's account
  \t\t\t4. Delete admin's account
  \t\t\t5. Return to previous menu\n\n"

  wrong_count=0

  while true
  do
    read -p "Enter number of needed function: " choosen_function
    case "$choosen_function" in
      "1" ) exec $HOME/.panel/account/root_add_user_account.sh;;
      "2" ) exec $HOME/.panel/account/root_delete_user_account.sh;;
      "3" ) exec $HOME/.panel/account/root_add_admin_account.sh;;
      "4" ) exec $HOME/.panel/account/root_delete_admin_account.sh;;
      "5" ) exec $HOME/.panel/root_panel_start.sh;;
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
