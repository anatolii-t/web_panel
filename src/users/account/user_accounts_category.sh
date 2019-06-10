#!/bin/bash
while true
do

  #Clear screen 
  echo -en "\ec"

  if [ ! -z "$ERROR_MESSAGE" ]
  then
    echo -e "\n${ERROR_MESSAGE}\n"
  fi

  echo -e "\t\t\tACCOUNT\n" 

  echo -e "
  Available function:
  \t\t\t1. Delete my account
  \t\t\t2. Return to previous menu\n\n"

  wrong_count=0

  while true
  do
    read -p "Enter number of needed function: " choosen_function
    case "$choosen_function" in
      "3" ) exec $HOME/.panel/account/user_delete_self_account.sh;;
      "4" ) exec $HOME/.panel/user_panel_start.sh;;
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
