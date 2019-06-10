while true
do
echo ---start---
read -p "Enter domain name new user: " entered_name_new_user

  if [ `echo $entered_name_new_user | wc -c` -eq "2" ] && ([ $entered_name_new_user = "." ] || [ $entered_name_new_user = "-" ])
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exit
    else
      echo "Invalid user name '$entered_name_new_user'"
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi
  wrong_count=0

  if [ `echo $entered_name_new_user | awk -F "" '{print $1}'` = "-" ]
  then
    if [ $wrong_count = "2" ]
    then
      echo 'ERROR! You are mistaken 3 times. Return to the previous menu after 5 seconds...'
      sleep 5
      exit
    else
      echo "User name cant start '-'"
      wrong_count=$[ $wrong_count + 1 ]
      continue
    fi
  fi

echo $entered_name_new_user
echo ---fifnish---
done
