#!/bin/bash

while true
do

  #sudo /usr/local/panel/bin/panel_header.sh clear_screen

  echo -e "
  Available category:
  \t\t\t1. WWW-domains
  \t\t\t2. Data bases
  \t\t\t3. FTP-accounts
  \t\t\t4. Account setings
  \t\t\t5. Exit\n\n"
  
  wrong_count=0

  while true
  do
    read -p "Enter number of needed category (type 'cancel' for return): " choosen_category
    case "$choosen_category" in
      "1" ) exec ./www_category_test.sh 
            wrong_count=0
            #break
      ;;
      "2" ) echo "./user_db_category.sh" 
            wrong_count=0
      ;;      
      "3" ) echo "./user_ftp_category.sh" 
            wrong_count=0
      ;;
      "4" ) echo "./user_settings_category.sh" 
            wrong_count=0
      ;;
      "5" ) exit ;;
      "cancel" ) break ;;
      #* ) echo "Wrong argument. Try again."
      #  wrong_count=$[ $wrong_count + 1 ]
      #  ;;
    #esac
    
    #if [ $wrong_count = "3" ]
    #then
    #  echo "You entered wrong argument 3 times. Return to the previous menu"
    #  break
    #fi
     * ) if [ $wrong_count = "2" ]
          then
            echo "ERROR! You entered wrong argument 3 times. Return to the previous menu"
            break
          else
            echo "Wrong argument. Try again." 
            wrong_count=$[ $wrong_count + 1 ]
          fi
     ;;
    esac

  done

done

