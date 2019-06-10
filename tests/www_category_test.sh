#!/bin/bash

while true
do

  #Clear screen 
  echo -en "\ec"
  
  if [ ! -z "$Neeeaded" ]
  then
    echo "$Neeeaded"
  fi

  #Need create script for list yser's sites here!
  #/usr/local/panel/bin/list_user_site.sh
  echo -e "\t\t\tWWW_DOMAINS\n"
  echo "LIST DOMAINS\n"
  echo -e "
  Available function:
  \t\t\t1. Add new WWW-domain
  \t\t\t2. Delete WWW-domain
  \t\t\t3. Edit WWW-domain
  \t\t\t4. List all your domains again
  \t\t\t5. Exit\n\n"

  wrong_count=0

  while true
  do
    read -p "Enter number of needed function (type 'cancel' for return): " choosen_function
    case "$choosen_function" in
      "1" ) echo "./user_www_add.sh"
            wrong_count=0
      ;;
      "2" ) echo "./user_www_delete.sh"
            wrong_count=0
      ;;
      "3" ) echo "./user_www_edit.sh"
            wrong_count=0
      ;;
      "4" ) echo "List domains here"
            #Need create script for list yser's sites here!
            #/usr/local/panel/bin/list_user_site.sh
            wrong_count=0
      ;;
      "5" ) exec ./list_test.sh ;; #break 3;;
      "cancel" ) break ;;
      * ) if [ $wrong_count = "2" ]
          then
             Neeeaded='ERROR! You entered wrong argument 3 times. Return to the previous menu'
             #Neeeaded='Errr'
            break
          else
            echo "Wrong argument. Try again." 
            wrong_count=$[ $wrong_count + 1 ]
          fi
      ;;
    esac
  done
done

