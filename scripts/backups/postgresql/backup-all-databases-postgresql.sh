#!/bin/bash
#
#  Script para backup de todas as databases
#
#                            noc@magnetwork.com.br
#
# versão: 1.0 
##############
export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

BKP_DIR="/var/lib/pgsql/backups"
if [ ! -d $BKP_DIR ]; then
    echo "Diretório $BKP_DIR não existe"
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
    echo "Precisa ser executado como root"
    exit 1
fi

DB_USER="postgres"
DB_PASSWORD=""
DATE=$(date +%d_%m_%Y-%H-%M_%S)
DATABASES="$( su - postgres -c "/usr/bin/psql -t -d template1 -c 'select datname from pg_database'"  |grep -v template)"

# define quantas copias de segurança serão armazenadas (default = 7)
KEEP_COPY="7"

# remove cópias antigas
for DB in $DATABASES; do
    COUNT=$(ls -1tr $BKP_DIR/$DB* | wc -l)
    if [ $COUNT -gt $KEEP_COPY ]; then
        for FILE in $(ls -1tr $BKP_DIR/$DB*); do
            if [ $COUNT -gt $KEEP_COPY ]; then
                rm -f $FILE 
                let COUNT--
            fi
        done
    fi
done

for DB in $DATABASES; do
    su - postgres -c "pg_dump $DB | gzip " > $BKP_DIR/$DB-$DATE-pgdump.sql.gz
    RET=$(echo $?)
    if [ $RET -ne 0 ]; then
        echo "Problemas no backup do banco $DB no servidor $(hostname) em $(date)" | mail -s "Problemas no PostgreSQL do banco $DB" noc@magnetwork.com.br
    fi
done
