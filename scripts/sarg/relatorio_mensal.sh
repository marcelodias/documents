#/bin/bash
#
# cria relatorio diário
#-----------------------------------------
export PATH="/bin:/usr/bin:/sbin:/usr/sbin"

TODAY=$(date +%d/%m/%Y)
MONTHLY=$(date --date "1 month ago" +%d/%m/%Y)
sarg -d $MONTHLY-$TODAY -o /var/www/sarg/monthly
