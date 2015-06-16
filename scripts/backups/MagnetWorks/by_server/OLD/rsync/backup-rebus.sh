#!/bin/bash
#
# Script de backup do servidor Rebus
#
#  <noc@magnetwork.com.br>
###########################
# Changelog
#  
#  12/01/2012  + Criação do script  - Marcelo Moreira de Mello <mmello@magnetwork.com.br>
#  12/03/2012  + Adicionado diretórios /etc /var/named /files /var/lib/libvirtd /vms - Marcelo Moreira de Mello <mmello@magnetwork.com.br>
#  14/03/2012  + Adicionado opção para envio de anexo junto com email - Marcelo Moreira de Mello <mmello@magnetwork.com.br>
#  14/03/2012  + Adicionado opção --inplace --sparse para manipulação de VMS - Marcelo Moreira de Mello  <mmello@magnetwork.com.br>
#              + Adicionado opção de snapshots - Marcelo Moreira de Mello <mmello@magnetwork.com.br>
#
#=======================================================
export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

export RSYNC_USER="rebus"
export RSYNC_MODULE="rebus"
export RSYNC_PASSWORD="lala"
export RSYNC_SERVER="spacewalk.magnetlab.com.br"

export VMS_SNAP_DIR="/vms-snap"

# opções
OPTS="--verbose --safe-links --recursive --owner --group --perms --times  --acls --xattrs --delete --compress --log-file=/var/log/rsync.log"
OPTS_VMS="--verbose --safe-links --recursive --compress --inplace --ignore-times --log-file=/var/log/rsync-vms.log"

# arquivos e diretorios que entram no backup
FILES="
	/etc
	/var/named 
	/root/bin 
	/files
	/var/log
    /var/lib/libvirt
      "
VMS="
    /vms-snap
    "
## executa backup
rsync $OPTS $FILES rsync://$RSYNC_USER@$RSYNC_SERVER/$RSYNC_MODULE 2>> /var/log/rsync-err.log
RET1=$(echo $?)

## snapshot
# cria lv-snap
lvcreate -s -L 2G -n vms-snap /dev/vg_rebus/lv.vms
mount /dev/vg_rebus/vms-snap /vms-snap
# backup 
rsync $OPTS_VMS $VMS rsync://$RSYNC_USER@$RSYNC_SERVER/$RSYNC_MODULE 2>> /var/log/rsync-vms-err.log
RET2=$(echo $?)

# desmonta e remove lv
umount /vms-snap
lvremove --force /dev/vg_rebus/vms-snap

for cond in $RET1 $RET2; do
    if [ $cond -ne 0 ]; then
        echo "Notificação de Backup" | mail -s "Problemas no script de backup no servidor $(hostname) em $(date)" noc@magnetwork.com.br
    fi
done

