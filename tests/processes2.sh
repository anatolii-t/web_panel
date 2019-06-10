#!/bin/bash
echo script 2
echo $USER
echo $SUDO_USER
echo $HOME
read -p "Neeaded status: " need_status

if [ "$need_status" = "1" ]
then
  echo status 1
  exit 1
fi

if [ "$need_status" = "0" ]
then 
  echo status 0
  exit 0
fi


#sleep 60
#exec sudo -u anatoliy /home/anatoliy/Downloads/dplm/tests/processes3.sh
