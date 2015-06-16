#!/bin/bash
#
# Script de backup do 389-ds <noc@magnetworks.com.br>
#
#----------------------------
#Changelog:
#
#  * 31/03/2012 - Marcelo Moreira de Mello <mmello@magnetworks.com.br>
#  - Criado script de backup
########################
export PATH="/bin:/sbin:/usr/sbin:/usr/bin"

# testa se user == root
WHOAMI=$(whoami)
if [ $WHOAMI != 'root' ]; then 
    echo "Script precisa ser executado como root!"
    exit
fi

# obtem nome da instance do 389-ds
DS_INSTANCE=$(ls -1d /etc/dirsrv/slapd* | cut -d'-' -f2)

# atualiza PATH
if [ -x /usr/lib64/dirsrv/slapd-$DS_INSTANCE/bak2db ]; then
    export PATH="$PATH:/usr/lib64/dirsrv/slapd-$DS_INSTANCE"
else
    export PATH="$PATH:/usr/lib/dirsrv/slapd-$DS_INSTANCE"
fi

# define quantas copias de segurança serão armazenadas (default = 30)
KEEP_COPY="30"

# remove cópias antigas
if [ -d "/var/lib/dirsrv/slapd-$DS_INSTANCE/bak" ]; then
    COUNT=$(ls -1tr /var/lib/dirsrv/slapd-$DS_INSTANCE/bak/ | wc -l)
    if [ $COUNT -gt $KEEP_COPY ]; then
        for DIR in $(ls -1tr /var/lib/dirsrv/slapd-$DS_INSTANCE/bak/)
            do
                if [ $COUNT -gt $KEEP_COPY ]; then
                    rm -rf /var/lib/dirsrv/slapd-$DS_INSTANCE/bak/$DIR
                    let COUNT--
                fi
            done
    fi
else
    echo "[99] - Não foi possível localizar diretório de backup"
    exit
fi

# gera novo backup
/usr/lib64/dirsrv/slapd-$DS_INSTANCE/db2bak &>/dev/null
