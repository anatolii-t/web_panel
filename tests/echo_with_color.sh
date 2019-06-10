#!/bin/bash

function write_install_log {
  while read -r text
  do
     echo -e $text
  done
}

m='1234'
message="\\t\e[31mWARNING!\e[0m Panel \"$m\" dir already exist, recreating dir..."
echo $message | write_install_log

echo -e '\\tWARNIN!` 111' | write_install_log
#echo -e '\\t\e[31mWARNING!\e[0m \"$m\" Panel dir already exist, recreating dir...'  | write_install_log

#sed -i 's|WARNING!|\\e[31mWARNING!\\e[0m|g' test.sh 
