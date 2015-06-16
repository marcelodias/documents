#!/bin/bash
#
# Script of remove for user FTP
#
# Developed by mdias 05/29/15
#
# Version 0.01
##################################

export PATH="/bin:/sbin:/usr/bin:/usr/sbin"
 
#======= Begin Variable =======#
#=======  End  Varible  =======#
if [ $(id -u) -eq 0 ]; then
    read -p "Enter username: " username
    egrep "^$username" /etc/passwd > /dev/null
    if [ $? -eq 0 ]; then
	userdel -r $username ; rm -frv /home/$username
	exit 1
    else
	echo "Não existe esse usuario"
	exit 2
    fi
fi
