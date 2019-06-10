#!/bin/bash

echo -en "\ec"

echo -e "\t\t\tAdding new WWW-domain\n"

trap 'exec $HOME/.panel/www/user_wwws_category.sh' SIGINT

wrong_count=0

#Enter domain name
while true
do
  read -p "Enter domain name new site: " entered_name_new_site
  
  #Turn domain into lower case
  entered_name_new_site=$(echo $entered_name_new_site | tr '[:upper:]' '[:lower:]')

  #Check symbols in domain
  if echo $entered_name_new_site | grep --color -q "[^а-яa-z0-9.-]"
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


  #Check string is domain 
  if ! echo $entered_name_new_site | grep -q -E \[.\]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/www/user_wwws_category.sh
    else
      echo 'You enter domain name without domain zone. Its incorrect.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0

  #Check domain pattern
  if [ `echo $entered_name_new_site | awk -F "." '{print $NF}' | wc -c` -le "2" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/www/user_wwws_category.sh
    else
      echo 'You enter domain name with zone that less than 2 characters. Allowed zone with 2 and more characters.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0


  #Check non-latin characters in domain and convert in punycode if need
  if echo $entered_name_new_site | grep -q "[^a-z0-9.-]"
  then
    entered_name_new_site=$(idn $entered_name_new_site 2> /dev/null)
    if [ $? = "1" ] 
    then
      if [ $wrong_count = "2" ]
      then
        echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
        sleep 5
        exec $HOME/.panel/www/user_wwws_category.sh
      else
        echo 'You enter domain name with non-latin characters. Your domain cant be more than 62 symbols in punycode'
        wrong_count=$[ $wrong_count + 1 ]
        continue
      fi
    fi
  fi

  #check domain lenght
  if [ `echo $entered_name_new_site | wc -c` -gt "257" ] 
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/www/user_wwws_category.sh
    else
      echo 'You enter too long domain name. Allowed lenght of domain - maximum 255 symbols.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
  if [ `echo $entered_name_new_site | wc -c` -lt "6" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/www/user_wwws_category.sh
    else
      echo 'You enter too short domain name. Allowed lenght of domain - minimum 4 symbols.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0

  #check domain not start -
  if [ `echo $entered_name_new_site | awk -F "" '{print $1}'` = "-" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/www/user_wwws_category.sh
    else
      echo "Domain name cant start '-'"
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi

  break
done


#PHP VERSION
#Create array with versions
php_versions=()
for version in `cat /usr/local/panel/var/php_versions`
do
  php_versions+=( $version )
done

#Enter php version
while true
do
  echo -e "Available versions:\n"
  cat /usr/local/panel/var/php_versions
  read -p "Enter neaded php version for new site: " entered_phpversion_new_site  
  if [[ ! " ${php_versions[@]} " =~ " ${entered_phpversion_new_site} " ]]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/www/user_wwws_category.sh
    else
      echo 'You enter wrong PHP versions. Try again.'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi  
  fi
  wrong_count=0
  break
done

#Enable/dont enable SSL
while true
do
  read -p "Enable SSL for new site? (yes/no): " enabling_ssl_new_site
  case "$enabling_ssl_new_site" in
      "yes" ) ssl_new_site="y";;
      "no" ) ssl_new_site="n";;
      * ) if [ $wrong_count = "2" ]
          then
            echo 'ERROR! You entered wrong argument 3 times. Return to the previous menu after 5 seconds...'
            sleep 5
            exec $HOME/.panel/www/user_wwws_category.sh
          else
            echo 'Pleas type "yes" or "no"' 
            wrong_count=$[ $wrong_count + 1 ]
            continue
          fi;;
  esac
  wrong_count=0
  break
done

#Enable/dont backup
while true
do
  read -p "Enable backup for new site? (yes/no): " enabling_backup_new_site
  case "$enabling_backup_new_site" in
      "yes" ) backup_new_site="y";;
      "no" ) backup_new_site="n";;
      * ) if [ $wrong_count = "2" ]
          then
            echo 'ERROR! You entered wrong argument 3 times. Return to the previous menu after 5 seconds...'
            sleep 5
            exec $HOME/.panel/www/user_wwws_category.sh
          else
            echo 'Pleas type "yes" or "no"' 
            wrong_count=$[ $wrong_count + 1 ]
            continue
          fi;;
  esac
  wrong_count=0
  break
done

sudo /usr/local/panel/bin/add_new_site.sh $entered_name_new_site $entered_phpversion_new_site $ssl_new_site $backup_new_site 
exec $HOME/.panel/www/user_wwws_category.sh
