#!/bin/bash

while true
do

  #Clear screen 
  echo -en "\ec"

  if [ ! -z "$ERROR_MESSAGE" ]
  then
    echo -e "\n${ERROR_MESSAGE}\n"
  fi


  echo -e "\t\t\tDATA BASES\n"   

  sudo /usr/local/panel/bin/list_db.sh
  sudo /usr/local/panel/bin/list_db_users.sh


  echo -e "
  Available function:
  \t\t\t1. Add new DB
  \t\t\t2. Delete DB
  \t\t\t3. Add new DB user
  \t\t\t4. Delete DB user
  \t\t\t5. Add user to DB 
  \t\t\t6. Delete user from DB
  \t\t\t7. Return to previous menu\n\n"

  wrong_count=0

  while true
  do
    read -p "Enter number of needed function: " choosen_function
    case "$choosen_function" in
      "1" ) exec $HOME/.panel/db/user_add_db.sh;;
      "2" ) exec $HOME/.panel/db/user_delete_db.sh;;
      "3" ) exec $HOME/.panel/db/user_add_db_user.sh;;
      "4" ) exec $HOME/.panel/db/user_delete_db_user.sh;;
      "5" ) exec $HOME/.panel/db/user_add_user_to_db.sh;;
      "6" ) exec $HOME/.panel/db/user_delete_user_from_db.sh;;
      "7" ) exec $HOME/.panel/user_panel_start.sh;;
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

