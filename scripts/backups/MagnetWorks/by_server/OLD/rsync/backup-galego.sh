#!/bin/bash
#
# Script de backup do servidor galego 
#
#  <noc@magnetwork.com.br>
###########################
# Changelog
#  
#  15/01/2012  + Criação do script  - Marcelo Moreira de Mello <mmello@magnetwork.com.br>
#
#=======================================================
export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

export RSYNC_USER="galego"
export RSYNC_MODULE="galego"
export RSYNC_PASSWORD="xje5"
export RSYNC_SERVER="spacewalk.magnetlab.com.br"

# opções
OPTS="--safe-links --recursive --owner --group --perms --times --delete --compress --log-file=/var/log/rsync.log"

# arquivos e diretorios que entram no backup
FILES="
	/etc
	/root/bin 
	/var/www
	/var/log
	/var/spool
	/usr/share/etherpad
	/databases-dump
      "
## executa backup
# remove log 
rm -f /var/log/rsync.log /var/log/rsync-err.log
rsync $OPTS $FILES rsync://$RSYNC_USER@$RSYNC_SERVER/$RSYNC_MODULE 2>/var/log/rsync-err.log

## se alguma coisa for fora do normal, manda email
RET=$(echo $?)
if [ $RET -ne 0 ]; then
    echo "Notificação de Backup" | mail -s "Problemas no script de backup no servidor $(hostname) em $(date)" -a /var/log/rsync.log noc@magnetwork.com.br
fi
