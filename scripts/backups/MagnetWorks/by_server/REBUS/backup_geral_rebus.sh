#!/bin/bash
#
# Script de backup do servidor Rebus
#
#  <noc@magnetwork.com.br>
###########################
# Changelog
#  09/04/2012  + Otimizado script e colocado em produção - Marcelo Mello <mmello@magnetwork.com.br> 
#  31/03/2012  + Criado script - Marcelo Moreira de Mello  <mmello@magnetwork.com.br>
#
#=======================================================
export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

# opções
OPTS="--exclude=/files2/VMS --links --safe-links --delete --recursive --owner --group --perms --times  --acls --xattrs --delete --compress --log-file=/var/log/rebus-rsync.log"

OPTS_VMS="--inplace  --copy-links --recursive --owner --group --perms --times  --acls --xattrs --delete --compress --log-file=/var/log/rebus-rsync-vms.log"

# arquivos e diretorios que entram no backup
FILES="
	/etc
	/var/named
	/home
	/files
	/files2	
	/var/lib
	/var/www
	/root/bin
	/var/log
      "

FILES_VMS="
	/vms
	/files2/VMS
  	"

## executa backup
rsync $OPTS $FILES /backup/rebus.magnetworks.com.br 
RET=$(echo $?)

rsync $OPTS_VMS $FILES_VMS /backup/rebus.magnetworks.com.br
RET1=$(echo $?)

if [ $RET -ne 0 ]; then
    echo "Notificação de Backup " | mail -s "Problemas no script de backup no servidor $(hostname) em $(date)" noc@magnetwork.com.br
fi

if [ $RET1 -ne 0 ]; then
    echo "Notificação de Backup VMS " | mail -s "Problemas no script de backup no servidor $(hostname) em $(date)" noc@magnetwork.com.br
fi
