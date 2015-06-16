#!/bin/bash
#####################################
#####        BACKUP v0.2        #####
#####  	    mdias 04/04/12 	#####
#####################################
 
# Dica de como agendar no cron para backup diario em tal horario
# 0 17 * * * /home/scripts/rbackup.sh
 
# DEFININDO VARIAVEIS
# Origens de Backup
ORIGEM1="/home/mdias/"
#ORIGEM2="/mnt/hdexterno2"
 
 
# Destino de backups (Uma Hd Externa)
DESTINO="/mnt/hdexterno/"
 
# Caminho dos logs e nome por data
#LOG="/var/www/backup_logs/`date +%d-%m-%y | tr / -`.log"
LOG="/home/mdias/logs_backup/`date +%d-%m-%y | tr / -`.log"
 
# Logs de leitura iniciais
echo "" >> $LOG
echo "" >> $LOG
echo "######################################" >> $LOG
echo "############ BACKUP V0.3 #############" >> $LOG
echo "######## BACKUP AUTOMATIZADO #########" >> $LOG
echo "######################################" >> $LOG
echo "" >> $LOG
echo Iniciando script................[OK] >> $LOG
echo Limpando logs antigos ..........[OK] >> $LOG
 
# Procura e remove logs com mais de 5 dias
#find /var/www/backup_logs -type f -mtime +5 -exec rm -rf {} ";"
find /home/mdias/logs_backup -type f -mtime +5 -exec rm -rf {} ";"
 
# Define o /dev da HD Externa (Para pegar o blkid do device use blkid como root no terminal)
DEVICE=`/sbin/blkid |grep  01CC723CA608A390 | awk -F: '{print $1}'`
 
# Desmonta e monta a HD Externa
umount -l $DEVICE
 
# Verifica se HD esta montada ou nao
# if mount -t ntfs-3g $DEVICE $DESTINO
if mount $DEVICE $DESTINO
then
   {
   # Se estiver montado, inicia a sincronia de HD Local e HD Externo somente
   echo "" >> $LOG
   echo "HD EXTERNA OK: Iniciando a sincronia de discos..." >> $LOG
   echo "" >> $LOG
   rsync -Cravp --delete $ORIGEM1 $DESTINO >> $LOG
#   rsync -auv --delete $ORIGEM2 $DESTINO >> $LOG
   echo "" >> $LOG
   echo "BACKUP REALIZADO COM SUCESSO!" >> $LOG
   }
else
  {
echo "" >> $LOG
echo "ERRO AO MONTAR HD EXTERNO: BACKUP CANCELADO!" >> $LOG
  }
fi
 
# Desmonta a HD ao finalizar
echo "Fim do Relatorio." >> $LOG
umount -l $DEVICE
