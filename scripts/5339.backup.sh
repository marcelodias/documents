#!/bin/bash
#####################################
#####        BACKUP v2.0        #####
#####  Romulo Grandini 06/03/12 #####
#####################################

# Dica de como agendar no cron para backup diario em tal horario
# 0 17 * * * /home/scripts/rbackup.sh

# DEFININDO VARIAVEIS
# Origens de Backup
ORIGEM1="/mnt/hd-1"
ORIGEM2="/mnt/hd-2"


# Destino de backups (Uma Hd Externa)
DESTINO="/mnt/backup"

# Caminho dos logs e nome por data
LOG="/var/www/backup_logs/`date +%d-%m-%y | tr / -`.log"

# Logs de leitura iniciais
echo "" >> $LOG
echo "" >> $LOG
echo "######################################" >> $LOG
echo "###           BACKUP v2.0          ###" >> $LOG
echo "######## BACKUP AUTOMATIZADO #########" >> $LOG
echo "######################################" >> $LOG
echo "" >> $LOG
echo Iniciando script................[OK] >> $LOG
echo Limpando logs antigos ..........[OK] >> $LOG

# Procura e remove logs com mais de 5 dias
find /var/www/backup_logs -type f -mtime +5 -exec rm -rf {} ";"

# Define o /dev da HD Externa (Para pegar o blkid do device use blkid como root no terminal)
DEVICE=`/sbin/blkid |grep  10C83EF3C83ED6A5 | awk -F: '{print $1}'`

# Desmonta e monta a HD Externa
umount -l $DEVICE

# Verifica se HD esta montada ou nao
if mount -t ntfs-3g $DEVICE $DESTINO
then
	{
	# Se estiver montado, inicia a sincronia de Hd-1 e Hd-3 somente
	echo "" >> $LOG
	echo "HD EXTERNA OK: Iniciando a sincronia de discos..." >> $LOG
	echo "" >> $LOG
	rsync -auv --delete $ORIGEM1 $DESTINO >> $LOG
	rsync -auv --delete $ORIGEM2 $DESTINO >> $LOG
	echo "" >> $LOG
	echo "BACKUP REALIZADO COM SUCESSO!" >> $LOG
	}
else
  {
echo "" >> $LOG
echo "ERRO AO MONTAR HD EXTERNA: BACKUP CANCELADO!" >> $LOG
  }
fi

# Desmonta a HD ao finalizar
echo "Fim do Relatorio." >> $LOG
umount -l $DEVICE
