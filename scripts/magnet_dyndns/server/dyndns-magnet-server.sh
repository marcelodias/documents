#!/bin/bash
#
# Script para atualização do zona de dns magnetworks.com.br interno
# atualizando os ips dos clientes
#
# versão v 0.1
#####################################
export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

DIR_FILES="/home/dyndns"
FILE_SUFFIX="-magnet-dynDNS.txt"
DNS_ZONE_FILE="/var/named/magnetworks.com.br.zone"

# executa backup do arquivo de zona
cp -a $DNS_ZONE_FILE $DNS_ZONE_FILE.bak

for file in $(ls $DIR_FILES/*$FILE_SUFFIX); do
    CLIENT_IP=$(cat $file)
    CLIENT_NAME=$(basename $file $FILE_SUFFIX)
    DNS_STRING="$CLIENT_NAME        IN A $CLIENT_IP"

    # testa se arquivo tem IP
    if [ -n "$CLIENT_IP" ]; then
        inZONE=$(grep -n $CLIENT_NAME $DNS_ZONE_FILE)
        if [ -n "$inZONE" ]; then
            # alterar hostname
            sed -i.old 's/^'"$CLIENT_NAME.*$"'/'"$DNS_STRING"'/g' $DNS_ZONE_FILE
        else
            # novo hostname
            echo "$CLIENT_NAME         IN A  $CLIENT_IP" >> $DNS_ZONE_FILE
        fi
    else
       cat $file | mail -s "Erro ao processo DynDNS do cliente $CLIENT_NAME em $(date)" noc@magnetwork.com.br
    fi
done

# reload dns
rndc reload &>/dev/null
