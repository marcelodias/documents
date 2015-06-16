### Variáveis ###
EMAIL_1=marcelo.dias@grupocielo.com.br
DATE=`date +%d_%m_%Y`
DATE_YE=`date +%d_%m_%Y -d "1 day ago"`
DATE_MO=`date +%d_%m_%Y -d "1 month ago"`
DATE_WE=`date +%d_%m_%Y -d "7 days ago"`
MONTHLY=`date +%m -d "1 month ago"`
YEAR=`date +%Y`
DATE_LA=`date +%d_%m_%Y -d "yesterday"`
DATE_BA=`echo $(date --date "now" +01_%m_%Y)`
INICIO=`date +%d/%m/%Y-%H:%M:%S`
LOG=/var/log/backup_bancos_$DATE.txt
### Fim variáveis ###

echo "$EMAIL_1"
echo "$DATE"
echo "$DATE_YE"
echo "$DATE_MO"
echo "$DATE_WE"
echo "$MONTHLY"
echo "$YEAR"
echo "Mostrar ultimo dia do mes $DATE_LA"
echo "$INICIO"
echo "$DATE_BA"
# Iniciando backup do final do mes
#        if [ "$DATE" = "$DATE_BA" ]; then
#                echo "Iniciado backup mensal do Mes $MONTHLY"
#                rsync -Cravpl /backup/cigam_$DATE_LA.dmp /backup_oficial/RASTRE/cigam/mes
#                rsync -Cravpl /backup/cigam_rastre_$DATE_LA.dmp /backup_oficial/RASTRE/cigam_rastre/mes
#                rsync -Cravpl /backup/intranet_$DATE_LA.dmp /backup_oficial/RASTRE/intranet/mes
#                rsync -Cravpl /backup/sas6_$DATE_LA.dmp /backup_oficial/RASTRE/sas/mes
#                echo "Termino do backup mensal do mes $MONTHLY"
#        else
#                echo "Backup mensal nao sera realizado, estamos no dia $DATE"
##                exit 1
#
#        fi
