#!/bin/bash

echo -en "\ec"

echo -e "\t\t\tDeleting WWW-domain\n"

trap 'exec $HOME/.panel/www/admin_wwws_category.sh' SIGINT

wrong_count=0

#Enter domain name
while true
do
  read -p "Enter domain name deleted site: " entered_name_deleted_site

  #Turn domain into lower case
  entered_name_deleted_site=$(echo $entered_name_deleted_site | tr '[:upper:]' '[:lower:]')

  #Check symbols in domain
  if echo $entered_name_deleted_site | grep --color -q "[^а-яa-z0-9.-]"
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exec $HOME/.panel/www/admin_wwws_category.sh
    else
      echo 'You enter domain name with wrong characters. Allowed characters is a-Z , а-Я , 0-9 and symbols .-'
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0
break
done

sudo /usr/local/panel/bin/delete_site.sh $entered_name_deleted_site
exec $HOME/.panel/www/admin_wwws_category.sh
