#!/bin/bash
echo "script 1----"
echo $USER
echo $SUDO_USER
echo "start script 2"
sudo /home/anatoliy/Downloads/dplm/tests/processes2.sh
echo "end script2"
echo "status script2 $?"
echo $USER
echo $SUDO_USER
echo "end script 1---"
