#!/bin/bash

new_admin=$1

trap '' SIGINT

. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector


if [ $panel_user="root" ]
then
  if [ -z $1 ]
  then
    echo "Error! Name of admin do not set! Usage add_admins_account.sh 'name new admin' "
    exit 1
  fi
  action_perfomed="add_new_admin"
  start_message="Adding admin $new_admin"
  echo "\\t$start_message" | logging
  useradd $new_admin -b /home/admins -m -U -s /bin/bash > /dev/null 2>>$panel_log
  usermod -a -G wheel $new_admin
  
  echo -e "Set new admin password
  \t\t\t1. Generate password
  \t\t\t2. Enter password manually"
  
  wrong_count="0"
  while true
  do
    read -p "Enter number of type set password: " choosen_category
    case "$choosen_category" in
      "1" ) new_admin_password=`pwgen -cns -N 1 21`
            (echo $new_admin_password;) | /usr/bin/passwd $new_admin --stdin >/dev/null
            echo "Setted password: $new_admin_password"
            break
            ;;
      "2" ) echo "Enter new password:"
            read -s -r  new_admin_password
            #Check symbols in user
            if [ `echo $new_admin_password | wc -c` -ge "42" ]
            then
              if [ $wrong_count = "2" ]
              then
                error_message="ERROR! You entered too long passwod 3 times."
                echo "\\t$error_message" | logging show
                echo "Exiting after 5 seconds..."
                sleep 5
                exit 1
              else
                echo 'You entered too long passwod. Maximum lenght - 40 symbols.' 
                wrong_count=$[ $wrong_count + 1 ]
                continue
              fi
            fi
            if [ `echo $new_admin_password | wc -c` -le "8" ]
            then
              if [ $wrong_count = "2" ]
              then
                error_message="ERROR! You entered too short passwod 3 times."
                echo "\\t$error_message" | logging show
                echo "Exiting after 5 seconds..."
                sleep 5
                exit 1
              else
                echo 'You entered too short passwod. Minimum lenght - 8 symbols.' 
                wrong_count=$[ $wrong_count + 1 ]
                continue
              fi
            fi
            (echo $new_admin_password;) | /usr/bin/passwd $new_admin --stdin >/dev/null
            break
            ;;
      * ) if [ $wrong_count = "2" ]
          then
            error_message="ERROR! You entered wrong argument setting password 3 times."
            echo "\\t$error_message" | logging show
            echo "Exiting after 5 seconds..."
            sleep 5
            exit 1
          else
            echo 'Pleas type "1" or "2"' 
            wrong_count=$[ $wrong_count + 1 ]
            continue
          fi;;
    esac
  done

  
  #copyying panel file and create .bash_profile
  cp -R /usr/local/panel/src/admins /home/admins/$new_admin/.panel

  find /home/admins/$new_admin/.panel -name '*sh' -type f -exec chmod 500 {} \;  

  echo '$HOME/.panel/admin_panel_start.sh' >> /home/admins/$new_admin/.bash_profile
  cp /root/.my.cnf /home/admins/$new_admin/.my.cnf

  mysql_connector "INSERT INTO admins VALUES ('${new_admin}')"
  
  ok_message="OK! Admin $new_admin successfully added!"
  echo "\\t$ok_message" | logging show
  echo "Exiting after 5 seconds..."
  sleep 5
  exit 0
    
else
  echo "Permission denied!"
  sleep 3
  exit 1
fi

