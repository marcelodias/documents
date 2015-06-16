#!/bin/bash
#
# Script de backup do servidor Rufus
#
#  <noc@magnetwork.com.br>
###########################
# Changelog
#  09/04/2012  + Otimizado script e colocado em produção - Marcelo Mello <mmello@magnetwork.com.br> 
#  31/03/2012  + Criado script - Marcelo Moreira de Mello  <mmello@magnetwork.com.br>
#
#=======================================================
export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

export RSYNC_USER="rufus"
export RSYNC_MODULE="rufus"
export RSYNC_PASSWORD="l@l@"
export RSYNC_SERVER="rebus.magnetworks.com.br"


# opções
OPTS="--links --safe-links --delete --recursive --owner --group --perms --times  --acls --xattrs --delete --compress --log-file=/var/log/rufus-rsync.log"

# arquivos e diretorios que entram no backup
FILES="
	/etc
    /var/satellite
	/var/lib
	/var/www
	/root/bin
	/var/log
    /var/cache/rhn
      "

## executa backup
rsync $OPTS $FILES rsync://$RSYNC_USER@$RSYNC_SERVER/$RSYNC_MODULE 2>/var/log/rufus-rsync-err.log
RET=$(echo $?)

if [ $RET -ne 0 ]; then
    echo "Notificação de Backup " | mail -s "Problemas no script de backup no servidor $(hostname) em $(date)" noc@magnetwork.com.br
fi

