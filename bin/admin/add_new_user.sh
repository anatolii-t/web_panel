#!/bin/bash
#--------VARIABLES START--------#
added_user_name=$1
#--------VARIABLES END----------#


. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables
. /usr/local/panel/bin/logging
. /usr/local/panel/bin/mysql_connector

if [ "$check_permission_admin" != "1" ] && [ $panel_user != "root" ]
then
  echo "Permission denied!"
  sleep 3
  exit 1
fi


action_perfomed="add_user"

start_message="Start adding user ${added_user_name}"
echo "\\t$start_message" | logging


#Checking existing user in database
user_in_database_is_exist=`mysql_connector "SELECT * FROM users WHERE name='$added_user_name'" | wc -l`
if [ $user_in_database_is_exist -gt 0 ]
then
  message="ERROR! User '$added_user_name' already added in panel! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

#Checking existing user in system
user_in_system_is_exist=`grep -E "^$added_user_name:" /etc/passwd | wc -l`
if [ $user_in_system_is_exist = "1" ]
then
  message="ERROR! User '$added_user_name' already added in system! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

#Checking existing user's folder
if [ -d /var/www/$added_user_name ]
then
  message="ERROR! User's  folder '/var/www/$added_user_name' already exist! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

#Checking existing folder for user's config files
#Apache
if [ -d /etc/httpd/vhosts/$added_user_name ]
then
  message="ERROR! Apache's  folder '/etc/nginx/vhosts/$added_user_name' for user's conf already exist! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi
if [ -d /etc/httpd/vhosts_php/$added_user_name ]
then
  message="ERROR! Apache's  folder '/etc/nginx/vhosts_php/$added_user_name' for user's php conf already exist! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi
#Nginx
if [ -d /etc/nginx/vhosts/$added_user_name ]
then
  message="ERROR! Nginx's  folder '/etc/nginx/vhosts/$added_user_name' for user's conf already exist! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi


#Creating user
useradd $added_user_name -b /var/www -m -U -s /bin/bash > /dev/null 2>>$panel_log
if [ "$?" != "0" ]
then
  message="ERROR! Can't add user '$added_user_name' in system! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi


echo -e "Set new user password
\t\t\t1. Generate password
\t\t\t2. Enter password manually"
  
wrong_count="0"
while true
do
  read -p "Enter number of type set password: " choosen_category
  case "$choosen_category" in
    "1" ) new_user_password=`pwgen -cns -N 1 21`
          (echo $new_user_password;) | /usr/bin/passwd $added_user_name --stdin >/dev/null
          echo "Setted password: $new_user_password"
          break
          ;;
    "2" ) echo "Enter new password:"
          read -s -r  new_user_password
          #Check symbols in user
          if [ `echo $new_user_password | wc -c` -ge "42" ]
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
          if [ `echo $new_user_password | wc -c` -le "8" ]
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
          (echo $new_user_password;) | /usr/bin/passwd $added_user_name --stdin >/dev/null
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


user_id=`id -u $added_user_name`
echo $new_user_password | ftpasswd --stdin --passwd --name $added_user_name --uid $user_id --home /var/www/$added_user_name --shell /bin/bash --file /etc/ftpd.passwd


#Insert record in databse
mysql_connector "INSERT INTO users VALUES ('${added_user_name}', '${panel_user}')" > /dev/null 2>>$panel_log
if [ "$?" != "0" ]
then
  message="ERROR! Can't add user '$added_user_name' in database! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi


#Adding user in group
usermod -a -G panel_users $added_user_name > /dev/null 2>>$panel_log
if [ "$?" != "0" ]
then
  message="ERROR! Can't add user '$added_user_name' in group! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi


#Creating folders in web-servers
mkdir /etc/httpd/vhosts/$added_user_name > /dev/null 2>>$panel_log
if [ "$?" != "0" ]
then
  message="ERROR! Can't create Apache's folder for '$added_user_name'! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi
mkdir /etc/httpd/vhosts_php/$added_user_name > /dev/null 2>>$panel_log
if [ "$?" != "0" ]
then
  message="ERROR! Can't create Apache's folder for php_confs user '$added_user_name'! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi



mkdir /etc/nginx/vhosts/$added_user_name > /dev/null 2>>$panel_log
if [ "$?" != "0" ]
then
  message="ERROR! Can't create Nginx's folder for '$added_user_name'! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

#Creating folders for user
#www dir
mkdir /var/www/$added_user_name/www > /dev/null 2>>$panel_log
if [ "$?" != "0" ]
then
  message="ERROR! Can't create www folder for '$added_user_name'! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi
#log dir
mkdir /var/www/$added_user_name/logs > /dev/null 2>>$panel_log
if [ "$?" != "0" ]
then
  message="ERROR! Can't create logs folder for '$added_user_name'! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi
mkdir /var/www/$added_user_name/logs/httpd > /dev/null 2>>$panel_log
if [ "$?" != "0" ]
then
  message="ERROR! Can't create Apache logs folder for '$added_user_name'! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi
mkdir /var/www/$added_user_name/logs/nginx > /dev/null 2>>$panel_log
if [ "$?" != "0" ]
then
  message="ERROR! Can't create Nginx logs folder for '$added_user_name'! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi
#data dir
mkdir /var/www/$added_user_name/data > /dev/null 2>>$panel_log
if [ "$?" != "0" ]
then
  message="ERROR! Can't create data folder for '$added_user_name'! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi
#tmp dir
mkdir /var/www/$added_user_name/tmp > /dev/null 2>>$panel_log
if [ "$?" != "0" ]
then
  message="ERROR! Can't create tmp folder for '$added_user_name'! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

#backu dir
mkdir /backup/users/$added_user_name > /dev/null 2>>$panel_log
if [ "$?" != "0" ]
then
  message="ERROR! Can't create general backup folder for '$added_user_name'! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi
mkdir /backup/users/$added_user_name/www > /dev/null 2>>$panel_log
if [ "$?" != "0" ]
then
  message="ERROR! Can't create www backup folder for '$added_user_name'! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi
mkdir /backup/users/$added_user_name/db > /dev/null 2>>$panel_log
if [ "$?" != "0" ]
then
  message="ERROR! Can't create db backup folder for '$added_user_name'! Exiting now!"
  echo "\\t$message" | logging show
  sleep 5
  exit 1
fi

#Copying scripts----------
cp -R /usr/local/panel/src/users /var/www/$added_user_name/.panel
find /var/www/$added_user_name/.panel -name '*sh' -type f -exec chmod 500 {} \;

chown -R $added_user_name: /var/www/$added_user_name

echo '$HOME/.panel/user_panel_start.sh' >> /var/www/$added_user_name/.bash_profile


mysql_user_password=`pwgen -cns -N 1 21`
mysql -e "CREATE USER '$added_user_name'@'localhost' IDENTIFIED BY '$mysql_user_password'"
echo "
[client]
user = $added_user_name
password = $mysql_user_password
" > /var/www/$added_user_name/.my.cnf


message="OK! User '$added_user_name' successfully created!" 
echo "\\t$message" | logging show
sleep 3

exit 0
