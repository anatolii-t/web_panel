#!/bin/bash
function logging {
  #showing_flag=$1
  if [ "$#" -gt 1 ] 
  then
    echo -e "\tERROR. To much variables"
  fi
  #echo $#
  while read -r text
  do
    LOGTIME=`date "+%Y-%m-%d %H:%M:%S"`
    #if [ "$showing_flag" == "show" ]; then
    #  echo -e $text
    #fi
    echo -e [$LOGTIME]":"[$USER]":"$text #>> $install_log
  done
}



site='test.com'
message="ERRO'R $site \n\t\t\t cant be added"

#echo -e '\\tOK' | logging 34
echo "\\t$message" | logging
