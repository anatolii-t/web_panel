#!/bin/bash

echo -en "\ec"

echo -e "\t\t\tEditting WWW-domain\n"

trap 'exec $HOME/.panel/www/user_wwws_category.sh' SIGINT

wrong_count=0

#Enter edited domain name
while true
do
  read -p "Enter domain edited site: " entered_name_edited_site
  
  #Turn domain into lower case
  entered_name_edited_site=$(echo $entered_name_edited_site | tr '[:upper:]' '[:lower:]')

  #Check symbols in domain
  if echo $entered_name_edited_site | grep -q "[^а-яa-z0-9.-]"
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/www/user_wwws_category.sh
    else
      echo 'You enter domain name with wrong characters. Allowed characters is a-Z , а-Я , 0-9 and symbols .-'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
break
done

#Chose what edit

#list properties domain----------------
sudo /usr/local/panel/bin/list_www_properties.sh full $entered_name_edited_site
if [ $? = "1" ]
then
  echo "ERROR! Site $entered_name_edited_site dont added in panel"
  echo "Return to previous menu after 5 second..."
  sleep 5
  exec $HOME/.panel/www/user_wwws_category.sh
fi

domain_properties=`sudo /usr/local/panel/bin/list_www_properties.sh short $entered_name_edited_site`
curent_php_version=`echo $domain_properties | awk '{print $3}'`
curent_logic_ssl_status=`echo $domain_properties | awk '{print $4}'`
curent_logic_backup_status=`echo $domain_properties | awk '{print $5}'`

if [ "$curent_logic_ssl_status" = "n" ]
then
  curent_ssl_status="Disabled"
else
  curent_ssl_status="Enabled"
fi

if [ "$curent_logic_backup_status" = "n" ]
then
  curent_backup_status="Disabled"
else
  curent_backup_status="Enabled"
fi


echo -e "
Current version PHP: $curent_php_version
Current SSL status: $curent_ssl_status
Current Backup status: $curent_backup_status

\tWhat do you want to change?"



if [ "$curent_logic_ssl_status" = "n" ] && [ "$curent_logic_backup_status" = "n" ]
then
  echo -e "
  \t\t\t1. Change PHP version
  \t\t\t2. Enable SSL for site
  \t\t\t3. Enable Backup for site
  \t\t\t4. Cancel\n\n"

  wrong_count=0

  while true
  do
    read -p "Enter number of needed function: " choosen_function
    case "$choosen_function" in
      "1" ) sudo /usr/local/panel/bin/change_php_version.sh $entered_name_edited_site
            exec $HOME/.panel/www/user_wwws_category.sh;;
      "2" ) sudo /usr/local/panel/bin/ssl_for_site.sh $entered_name_edited_site enable_ssl
            exec $HOME/.panel/www/user_wwws_category.sh;;
      "3" ) sudo /usr/local/panel/bin/backup_for_site.sh $entered_name_edited_site enable_backup
            exec $HOME/.panel/www/user_wwws_category.sh;;
      "4" ) exec $HOME/.panel/www/user_wwws_category.sh;;
      * ) if [ $wrong_count = "2" ]
          then
            ERROR_MESSAGE='ERROR! You entered wrong argument 3 times. Return to the previous menu'
            exec $HOME/.panel/www/user_wwws_category.sh
          else
            echo "Wrong argument. Try again." 
            wrong_count=$[ $wrong_count + 1 ]
          fi
      ;;
    esac
  done


elif [ "$curent_logic_ssl_status" = "y" ] && [ "$curent_logic_backup_status" = "n" ]
then
  echo -e "
  \t\t\t1. Change PHP version
  \t\t\t2. Disable SSL for site
  \t\t\t3. Enable Backup for site
  \t\t\t4. Cancel\n\n"

  wrong_count=0

  while true
  do
    read -p "Enter number of needed function: " choosen_function
    case "$choosen_function" in
      "1" ) sudo /usr/local/panel/bin/change_php_version.sh $entered_name_edited_site
            exec $HOME/.panel/www/user_wwws_category.sh;;
      "2" ) sudo /usr/local/panel/bin/ssl_for_site.sh $entered_name_edited_site disable_ssl
            exec $HOME/.panel/www/user_wwws_category.sh;;
      "3" ) sudo /usr/local/panel/bin/backup_for_site.sh $entered_name_edited_site enable_backup
            exec $HOME/.panel/www/user_wwws_category.sh;;
      "4" ) exec $HOME/.panel/www/user_wwws_category.sh;;
      * ) if [ $wrong_count = "2" ]
          then
            ERROR_MESSAGE='ERROR! You entered wrong argument 3 times. Return to the previous menu'
            exec $HOME/.panel/www/user_wwws_category.sh
          else
            echo "Wrong argument. Try again." 
            wrong_count=$[ $wrong_count + 1 ]
          fi
      ;;
    esac
  done



elif [ "$curent_logic_ssl_status" = "n" ] && [ "$curent_logic_backup_status" = "y" ]
then
  echo -e "
  \t\t\t1. Change PHP version
  \t\t\t2. Enable SSL for site
  \t\t\t3. Disable Backup for site
  \t\t\t4. Cancel\n\n"

  wrong_count=0

  while true
  do
    read -p "Enter number of needed function: " choosen_function
    case "$choosen_function" in
      "1" ) sudo /usr/local/panel/bin/change_php_version.sh $entered_name_edited_site
            exec $HOME/.panel/www/user_wwws_category.sh;;
      "2" ) sudo /usr/local/panel/bin/ssl_for_site.sh $entered_name_edited_site enable_ssl
            exec $HOME/.panel/www/user_wwws_category.sh;;
      "3" ) sudo /usr/local/panel/bin/backup_for_site.sh $entered_name_edited_site disable_backup
            exec $HOME/.panel/www/user_wwws_category.sh;;
      "4" ) exec $HOME/.panel/www/user_wwws_category.sh;;
      * ) if [ $wrong_count = "2" ]
          then
            ERROR_MESSAGE='ERROR! You entered wrong argument 3 times. Return to the previous menu'
            exec $HOME/.panel/www/user_wwws_category.sh
          else
            echo "Wrong argument. Try again." 
            wrong_count=$[ $wrong_count + 1 ]
          fi
      ;;
    esac
  done



elif [ "$curent_logic_ssl_status" = "y" ] && [ "$curent_logic_backup_status" = "y" ]
then
  echo -e "
  \t\t\t1. Change PHP version
  \t\t\t2. Disable SSL for site
  \t\t\t3. Disable Backup for site
  \t\t\t4. Cancel\n\n"

  wrong_count=0

  while true
  do
    read -p "Enter number of needed function: " choosen_function
    case "$choosen_function" in
      "1" ) sudo /usr/local/panel/bin/change_php_version.sh $entered_name_edited_site
            exec $HOME/.panel/www/user_wwws_category.sh;;
      "2" ) sudo /usr/local/panel/bin/ssl_for_site.sh $entered_name_edited_site disable_ssl
            exec $HOME/.panel/www/user_wwws_category.sh;;
      "3" ) sudo /usr/local/panel/bin/backup_for_site.sh $entered_name_edited_site disable_backup
            exec $HOME/.panel/www/user_wwws_category.sh;;
      "4" ) exec $HOME/.panel/www/user_wwws_category.sh;;
      * ) if [ $wrong_count = "2" ]
          then
            ERROR_MESSAGE='ERROR! You entered wrong argument 3 times. Return to the previous menu'
            exec $HOME/.panel/www/user_wwws_category.sh
          else
            echo "Wrong argument. Try again." 
            wrong_count=$[ $wrong_count + 1 ]
          fi
      ;;
    esac
  done
fi

