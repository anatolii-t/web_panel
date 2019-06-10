#!/bin/bash

trap 'exec $HOME/.panel/account/user_accounts_category.sh' SIGINT

echo -en "\ec"
 
echo -e "\t\t\tDeleting self account\n"

wrong_count=0

for mess_count in {1..3}
do
  echo -e "\t\t\tWARNING! WARNING! WARNING!"
  echo -e "\tAll you data will be deleted. You lose access to server."
done

echo -e "\n\n"

while true
do
  read -p "Are you shure that you want delete your accont?(y/n): " choice
  case "$choice" in
    "y" ) sudo /usr/local/panel/bin/user/delete_account_myself.sh $USER;;
    "n" ) exec $HOME/.panel/account/user_accounts_category.sh;;
    * ) if [ $wrong_count = "2" ]
        then
          ERROR_MESSAGE='ERROR! You entered wrong argument 3 times. Return to the previous menu'
          exec $HOME/.panel/account/user_accounts_category.sh
        else
          echo "Wrong argument. Type 'y' or 'n'." 
          wrong_count=$[ $wrong_count + 1 ]
        fi
    ;;
  esac
done
