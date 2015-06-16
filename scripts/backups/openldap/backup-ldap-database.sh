#!/bin/bash
#
#  Script para backup da database openLDAP
#                          noc@magnetwork.com.br
#
# TODO: criar rotacionamento no logs
#
###################
export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

export EXP_DIR="/backup-ldap"
export DATA=$(date +%B_%d_%Y-%H_%M_%S)

#backup com slapcat
slapcat -l $EXP_DIR/slapcat_dump-$DATA.ldif 
RET1=$(echo $?)

#backup com ldapsearch
ldapsearch -x -D "cn=Manager,dc=magnetworks,dc=com,dc=br" -w "XXXXXXXXXX" -LLL > $EXP_DIR/ldapsearch_dump-$DATA.ldif
RET2=$(echo $?)

# ajusta permissão
chmod 700 $EXP_DIR/ldapsearch_dump-$DATA.ldif
chmod 700 $EXP_DIR/slapcat_dump-$DATA.ldif

for cond in $RET1 $RET2; do
    if [ $cond -ne 0 ]; then
        echo "Notificação de Backup da base openLDAP" | mail -s "Problemas no script de backup no servidor $(hostname) em $(date)" noc@magnetwork.com.br
    fi
done
