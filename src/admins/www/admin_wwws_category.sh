#!/bin/bash

while true
do

  #Clear screen 
  echo -en "\ec"
 
  if [ ! -z "$ERROR_MESSAGE" ]
  then
    echo -e "\n${ERROR_MESSAGE}\n"
  fi


  echo -e "\t\t\tWWW DOMAINS\n"   

  sudo /usr/local/panel/bin/list_www.sh
 
  
  echo -e "
  Available function:
  \t\t\t1. Add new WWW-domain
  \t\t\t2. Delete WWW-domain
  \t\t\t3. Edit WWW-domain
  \t\t\t4. Exit\n\n"

  wrong_count=0

  while true
  do
    read -p "Enter number of needed function: " choosen_function
    case "$choosen_function" in
      "1" ) exec $HOME/.panel/www/admin_www_add.sh;;
      "2" ) exec $HOME/.panel/www/admin_www_delete.sh;;
      "3" ) exec $HOME/.panel/www/admin_www_edit.sh;;
      "4" ) exec $HOME/.panel/admin_panel_start.sh;;
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

