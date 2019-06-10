#!/bin/bash

. /usr/local/panel/bin/check_user
. /usr/local/panel/var/panel_variables

if [ "$1" = "clear_screen" ]
then
echo -en "\ec"
fi
echo -e "\t\t ================================================
\t\t|\t\t      Hello!     \t\t |
\t\t|\t\tIt is WEB-PANEL!\t\t |
\t\t|\t   You are loggined as $panel_user_inf\t |
\t\t|  \t\t Have a nice work\t\t |
\t\t ================================================"

