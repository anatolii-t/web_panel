#!/bin/bash

while true
do

  #Clear screen 
  echo -en "\ec"

  if [ ! -z "$ERROR_MESSAGE" ]
  then
    echo -e "\n${ERROR_MESSAGE}\n"
  fi


  echo -e "\t\t\tSERVICES\n"   

  echo -e "
  Available services:
  \t\t\t1. Apache
  \t\t\t2. Nginx
  \t\t\t3. FTP
  \t\t\t4. MySQL
  \t\t\t5. Return to previous menu\n\n"

  wrong_count=0

  while true
  do
    read -p "Enter number of needed service: " choosen_service
    case "$choosen_service" in
      "1" ) echo -e "\tApache"
            echo -e  "Available function:
            \t\t1. Check status
            \t\t2. Stop service
            \t\t3. Restart service
            \t\t4. Start service
            \t\t5. Return ro previous menu 
            "
            while true
            do
              read -p "Enter number of needed function: " choosen_function
              case "$choosen_function" in
                "1" ) sudo systemctl status httpd
                break 2
                ;;
                "2" ) sudo systemctl stop httpd
                break 2
                ;;
                "3" ) sudo systemctl restart httpd
                break 2
                ;;
                "4" ) sudo systemctl start httpd
                break 2   
                ;;
                "5" ) break 2;;
                * ) if [ $wrong_count = "2" ]
                    then
                      ERROR_MESSAGE='ERROR! You entered wrong argument 3 times. Return to the previous menu'
                      break 2
                    else
                      echo "Wrong argument. Try again." 
                      wrong_count=$[ $wrong_count + 1 ]
                    fi
                    ;;
               esac
             done
      ;;
      "2" ) echo -e "\tNginx"
            echo -e  "Available function:
            \t\t1. Check status
            \t\t2. Stop service
            \t\t3. Restart service
            \t\t4. Start service
            \t\t5. Return ro previous menu 
            "
            while true
            do
              read -p "Enter number of needed function: " choosen_function
              case "$choosen_function" in
                "1" ) sudo systemctl status nginx
                break 2
                ;;
                "2" ) sudo systemctl stop nginx
                break 2
                ;;
                "3" ) sudo systemctl restart nginx
                break 2
                ;;
                "4" ) sudo systemctl start nginx
                break 2
                ;;
                "5" ) break 2;;
                * ) if [ $wrong_count = "2" ]
                    then
                      ERROR_MESSAGE='ERROR! You entered wrong argument 3 times. Return to the previous menu'
                      break 2
                    else
                      echo "Wrong argument. Try again." 
                      wrong_count=$[ $wrong_count + 1 ]
                    fi
                    ;;
               esac
             done
      ;;
      "3" ) echo -e "\tFTP"
            echo -e  "Available function:
            \t\t1. Check status
            \t\t2. Stop service
            \t\t3. Restart service
            \t\t4. Start service
            \t\t5. Return ro previous menu 
            "
            while true
            do
              read -p "Enter number of needed function: " choosen_function
              case "$choosen_function" in
                "1" ) sudo systemctl status proftpd
                break 2
                ;;
                "2" ) sudo systemctl stop proftpd
                break 2
                ;; 
                "3" ) sudo systemctl restart proftpd
                break 2
                ;;
                "4" ) sudo systemctl start proftpd
                break 2
                ;;
                "5" ) break 2;;
                * ) if [ $wrong_count = "2" ]
                    then
                      ERROR_MESSAGE='ERROR! You entered wrong argument 3 times. Return to the previous menu'
                      break 2
                    else
                      echo "Wrong argument. Try again." 
                      wrong_count=$[ $wrong_count + 1 ]
                    fi
                    ;;
               esac
             done
      ;;
      "4" ) echo -e "\tMySQL"
            echo -e  "Available function:
            \t\t1. Check status
            \t\t2. Stop service
            \t\t3. Restart service
            \t\t4. Start service
            \t\t5. Return ro previous menu 
            "
            while true
            do
              read -p "Enter number of needed function: " choosen_function
              case "$choosen_function" in
                "1" ) sudo systemctl status mariadb
                break 2
                ;;
                "2" ) sudo systemctl stop mariadb
                break 2
                ;;
                "3" ) sudo systemctl restart mariadb
                break 2
                ;;
                "4" ) sudo systemctl start mariadb
                break 2
                ;;
                "5" ) break 2;;
                * ) if [ $wrong_count = "2" ]
                    then
                      ERROR_MESSAGE='ERROR! You entered wrong argument 3 times. Return to the previous menu'
                      break 2
                    else
                      echo "Wrong argument. Try again." 
                      wrong_count=$[ $wrong_count + 1 ]
                    fi
                    ;;
               esac
             done
      ;;
      "5" ) exec $HOME/.panel/admin_panel_start.sh;;
      * ) if [ $wrong_count = "2" ]
          then
            ERROR_MESSAGE='ERROR! You entered wrong argument 3 times. Return to the previous menu'
            break 2
          else
            echo "Wrong argument. Try again." 
            wrong_count=$[ $wrong_count + 1 ]
          fi
      ;;
    esac
  done
done

