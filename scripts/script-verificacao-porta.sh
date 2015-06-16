#!/bin/bash

#------------------------------------------#
#  Script de Verificacao da porta 1863 MSN #
#         Marcelo Trindade Dias            #
#            versao v. 0.1                 #
#------------------------------------------#

export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

#============Inicio Variaveis============#

PORTAMSNABERTA=netstat -vanpt | grep -w 0.0.0.0:1863 | awk -F: '{print $2}'
PORTAMSNOK=1863                0.0.0.0
