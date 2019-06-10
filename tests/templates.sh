#!/bin/bash
config_file_nginx='nginx.conf'
config_file_apache='apache.conf'
template_nginx_file='nginx.template'
template_apache_file='apache.template'

test_user='andriy'
site='google.com'


template_apache=`cat ${template_apache_file}`
eval "echo \"${template_apache}\"" > apache.conf

template_nginx=`cat ${template_nginx_file}`
eval "echo \"${template_nginx}\"" > nginx.conf
