#!/bin/bash
# Conecta usando port knocking Magnet - noc@magnetwork.com.br

export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

PORTS="123:tcp 456:udp ..."
if [ -z $1 ]; then
    USER=$(whoaim)
else
    USER=$1
fi
SERVER="vpn.magnetworks.com.br"

for port in $PORTS;
    do
        knock $SERVER $port
        sleep 1
    done

sleep 1
ssh $USER@$SERVER
