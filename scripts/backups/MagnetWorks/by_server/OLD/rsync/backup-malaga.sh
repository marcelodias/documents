#!/bin/bash
#
# Script de backup do servidor malaga 
#
#  <noc@magnetwork.com.br>
###########################
# Changelog
#  
#  14/01/2012  + Criação do script  - Marcelo Moreira de Mello <mmello@magnetwork.com.br>
#
#=======================================================
export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

export RSYNC_USER="malaga"
export RSYNC_MODULE="malaga"
export RSYNC_PASSWORD="h0l4"
export RSYNC_SERVER="spacewalk.magnetlab.com.br"

# opções
OPTS="--safe-links --recursive --owner --group --perms --times --delete --compress --log-file=/var/log/rsync.log"

# arquivos e diretorios que entram no backup
FILES="
	/etc
	/root/bin 
	/var/www
	/srv/git
	/var/log
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
