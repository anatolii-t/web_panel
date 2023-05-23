# Web panel
CLI web-server management panel

## About Web panel

Web panel - is a personal project, mainly created for studying.
Written using Bash.
Main services available for customers - Apache, Nginx, MySQL, ProFTPD.
For saving system information i was using MySQL.

## Requirements

  + CentOS 7
  + root access over ssh

## Installing

`$ wget https://raw.githubusercontent.com/velgi/web_panel/master/install.sh`  
`$ /bin/bash install.sh`  

## Functionality

  + Support all basic functions for managing web-server and even somehow treating it as shared machine. Main functions are - creating/changing/deleting user, FTP-user, sites, DBs, installing SSL-certificates (existing or generation self-signed)
  + Separation on 3 access layers: 
    + user
    + admin (can manage own users and theit content)
    + root (can manage all users and admins and their content)
  + Supporting multiplie PHP versions (CGI mode)
  + Loggin panel actions (in /usr/local/panel/log)
    
## Detail

  + Security of the panel itself might be not greatest, but developed using sudoers, correctly picked permissions for scripts and writing additional code, which is checking user and affect their permissions (file bin/check_user) ;
  + Unfortunatelly, some of the tools weren't tested ;
  + Some functions, like installing SSL Lets Encrypt or creating auto backup system wasn't implemented, even if was planned in the first place;
  + Unfortunatelly, general server security wasn't additionaly tweaked and chacked, even in opposite - for example IPtables is stopped
  
