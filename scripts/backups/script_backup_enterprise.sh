#!/bin/bash
#########################################################
#                                                       #
#            Backup dos Bancos Monitoramento            #
#                                                       #
#                v.1.2.0.2 Marcelo Dias                 #
#########################################################       
### Variáveis ###
EMAIL_1=marcelo.dias@grupocielo.com.br
DATE=`date +%d_%m_%Y`
DATE_YE=`date +%d_%m_%Y -d "1 day ago"`
DATE_MO=`date +%d_%m_%Y -d "1 month ago"`
DATE_WE=`date +%d_%m_%Y -d "30 days ago"`
MONTHLY=`date +%m`
YEAR=`date +%Y`
DATE_LA=`date +%d_%m_%Y -d "yesterday"`
DATE_BA=`echo $(date --date "now" +01_%m_%Y)`
INICIO=`date +%d/%m/%Y-%H:%M:%S`
LOG=/var/log/backup_banco_monitoramento_$DATE.txt
### Fim variáveis ###

echo " " >> $LOG
echo " " >> $LOG
echo "|-----------------------------------------------" >> $LOG
echo " Backup iniciado em $INICIO" >>$LOG
# Iniciando Backup no HD 8TB
        rsync -Cravpl /backup/monitoramento_$DATE_YE.dmp /backup_oficial/ENTERPRISE/monitoramento >> $LOG
# Finalizando Backup

# Removendo Backup de 30 dias no Servidor Enterprise 
        rm -fr /backup/monitoramento_$DATE_WE.dmp >> $LOG
# Finalizando remocao do backup com mais de 30 dias

# Iniciando Remocao backup de um Mes
        rm -fR /backup_oficial/ENTERPRISE/monitoramento/monitoramento_$DATE_MO.dmp >> $LOG
# Fim Remocao backup de um Mes

FINAL=`date +%d/%m/%Y-%H:%M:%S`

echo " Sincronização Finalizada em $FINAL" >> $LOG
echo "|-----------------------------------------------" >> $LOG
echo " " >> $LOG
echo " " >> $LOG

# Iniciando backup do final do mes
        if [ "$DATE" = "$DATE_BA" ]; then
                echo "Iniciado backup mensal do Mes $MONTHLY" >> $LOG
                rsync -Cravpl /backup/monitoramento_$DATE_LA.dmp /backup_oficial/ENTERPRISE/monitoramento/mes >> $LOG
                echo "Termino do backup mensal do mes $MONTHLY" >> $LOG
        else
                echo "Backup mensal nao sera realizado, estamos no dia $DATE" >> $LOG
#                exit 1

        fi

#### Enviar e-mail do log ####
                mutt -s "Backup Externo realizado com sucesso em $(date "+%d-%m-%y %H:%M:%S")" "$EMAIL_1" < $LOG
