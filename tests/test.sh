#!/bin/bash
#if grep -qrl 'fWWW-domains' /home/anatoliy/Downloads/dplm/tests/list_test.sh 
#then
#  echo true
#else
#  echo false
#fi

entered_name_new_site='яfjgdhghdfgkhdgjdjlgjgjldjgkldjgkldjgkldjgkldjgkljdgkljlgkldhgkldgilhkldgjldfjgldgkldjgkljdfgпппп.ком'
if echo $entered_name_new_site | grep --color -q "[^a-z0-9.-]"
then
  #entered_name_new_site=$(idn $entered_name_new_site 2> /dev/null)
  entered_name_new_site=$(idn $entered_name_new_site)
  echo $?
fi
echo $entered_name_new_site

