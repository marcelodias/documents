#!/bin/bash
#
# Script de backup do servidor gloriam
#
#  <noc@magnetwork.com.br>
###########################
# Changelog
#  09/04/2012  + Otimizado script e colocado em produção - Marcelo Mello <mmello@magnetwork.com.br> 
#  31/03/2012  + Criado script - Marcelo Moreira de Mello  <mmello@magnetwork.com.br>
#
#=======================================================
export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

export RSYNC_USER="gloriam"
export RSYNC_MODULE="gloriam"
export RSYNC_PASSWORD="l0l@"
export RSYNC_SERVER="rebus.magnetworks.com.br"


# opções
OPTS="--links --safe-links --delete --recursive --owner --group --perms --times  --acls --xattrs --delete --compress --log-file=/var/log/gloriam-rsync.log"

# arquivos e diretorios que entram no backup
FILES="
	/etc
	/var/lib
	/var/www
	/root/bin
	/var/log
    /srv/git
      "

## executa backup
rsync $OPTS $FILES rsync://$RSYNC_USER@$RSYNC_SERVER/$RSYNC_MODULE 2>/var/log/gloriam-rsync-err.log
RET=$(echo $?)

# erro 24 por causa de arquivos removidos (graficos visualização)
if [ $RET -eq 0  ] || [ $RET -eq 24 ]; then
    echo "Backup Concluído em $(date)" >> /var/log/gloriam-rsync.log
else
    echo "Notificação de Backup " | mail -s "Problemas no script de backup no servidor $(hostname) em $(date)" noc@magnetwork.com.br
fi

