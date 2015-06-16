#/bin/bash
#
# cria relatorio diário
#-----------------------------------------
export PATH="/bin:/usr/bin:/sbin:/usr/sbin"

TODAY=$(date --date "0 day ago" +%d/%m/%Y)
sarg -d $TODAY-$TODAY -o /var/www/sarg/daily
