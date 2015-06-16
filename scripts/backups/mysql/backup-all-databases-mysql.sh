#!/bin/bash
#
#  Script para backup de todas as databases
#
#                            noc@magnetwork.com.br 
# versão: 1.0
##############
export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

BKP_DIR="/etc/mysql-backups"
if [ ! -d $BKP_DIR ]; then
    echo "Diretório $BKP_DIR não existe"
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
    echo "Precisa ser executado como root"
    exit 1
fi

DB_USER="root"
DB_PASSWORD="M4gN3t1c"
DB_HOST="localhost"
DATE=$(date +%d_%m_%Y-%H-%M_%S_%N)
DATABASES="$(mysql -u $DB_USER -h $DB_HOST -p$DB_PASSWORD -Bse 'show databases' | grep -v information_schema)"

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
    #su - postgres -c "pg_dump $DB | gzip " > $BKP_DIR/$DB-$DATE-pgdump.sql.gz
    mysqldump --user=$DB_USER --password=$DB_PASSWORD $DB > $BKP_DIR/$DB-$DATE-mysqldump.sql.gz
    RET=$(echo $?)
    if [ $RET -ne 0 ]; then
        echo "Problemas no backup do banco $DB no servidor $(hostname) em $(date)" | mail -s "Problemas no MySQL do banco $DB" noc@magnetwork.com.br
    fi
done

