#!/bin/bash			    #
#				    #
#  Script of creation for user FTP  #
#				    #
#    Developed by mdias 05/29/15    #
#				    #
#	    Version 0.1		    #
#####################################

export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

#======= Begin Variable =======#
# Username
read -p "Enter username: " username

# Password
read -s -p "Enter password: " password

# Set work group ftp
grupoxml=xmlusers

# Home User
homeuser=/home/$username

# Folder Comandos
comandos=$homeuser/comandos

# Folder Recebidos
recebidos=$homeuser/recebidos

#=======  End Variable  =======#

if [ $(id -u) -eq 0 ]; then
    egrep "^$username" /etc/passwd > /dev/null
    if [ $? -eq 0 ]; then
	echo "$username exists!"
	exit 1
    else
	pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
	useradd -m -p $pass $username
	usermod -g $grupoxml $username
	chown root.root $homeuser
	chmod 755 $homeuser
	mkdir $comandos $recebidos
	chown -R "$username"."$grupoxml" $comandos $recebidos
	chmod 770 $comandos $recebidos
	[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
    fi 
else
    echo "Only root may add a user to the system"
    exit 2
fi
