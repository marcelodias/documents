#/bin/bash
#
# cria relatorio diário
#-----------------------------------------
export PATH="/bin:/usr/bin:/sbin:/usr/sbin"

TODAY=$(date +%d/%m/%Y)
WEEKLY=$(date --date "1 week ago" +%d/%m/%Y)
sarg -d $WEEKLY-$TODAY -o /var/www/sarg/weekly
