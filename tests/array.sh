#!/bin/bash
php_version=()
for i in `cat ./cgi_php`
do
  echo $i
  php_version+=( $i )
done

echo ${php_version[@]}

read -p "Enter tested element: " tested_element
echo $tested_element

if [[ " ${php_version[@]} " =~ " ${tested_element} " ]]; then
    # whatever you want to do when arr contains value
  echo true
else
  echo false
fi
