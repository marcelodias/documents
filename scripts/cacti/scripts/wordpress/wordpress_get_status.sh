#!/bin/bash
#
# Get status from posts from Wordpress
# Author: Marcelo Moreira de Mello
#
#########################
DISABLE_CMDLINE_MODE="0"

# if DISABLE_CMDLINE_MODE=1 then set the values below
USER=xxxxxx
PASSWORD=vxxxxxx
DATABASE=wxxxxx
HOST=localhost

if [ $DISABLE_CMDLINE_MODE -eq 0 ]; then 
    if [ $# -ne 4 ]; then
        echo "Usage: $0 db_user db_password db_name db_host"
        exit 1
    fi
    USER=$1
    PASSWORD=$2
    DATABASE=$3
    HOST=$4
fi

# published
mysql -u $USER -p$PASSWORD -h $HOST $DATABASE -N -E --execute="select  count(*) from wrd_pressposts where post_status = 'publish';" | grep -v '*' | awk '{ printf "publish:%s ", $1 }'
 
# draft
mysql -u $USER -p$PASSWORD -h $HOST $DATABASE -N -E --execute="select  count(*) from wrd_pressposts where post_status = 'draft';" | grep -v '*' | awk '{ printf "draft:%s ", $1 }'

# pending
mysql -u $USER -p$PASSWORD -h $HOST $DATABASE -N -E --execute="select  count(*) from wrd_pressposts where post_status = 'pending';" | grep -v '*' | awk '{ printf "pending:%s ", $1 }'

#trash
mysql -u $USER -p$PASSWORD -h $HOST $DATABASE -N -E --execute="select  count(*) from wrd_pressposts where post_status = 'trash';" | grep -v '*' | awk '{ printf "trash:%s ", $1 }'

# future
mysql -u $USER -p$PASSWORD -h $HOST $DATABASE -N -E --execute="select  count(*) from wrd_pressposts where post_status = 'future';" | grep -v '*' | awk '{ printf "future:%s ", $1 }'

# private
mysql -u $USER -p$PASSWORD -h $HOST $DATABASE -N -E --execute="select  count(*) from wrd_pressposts where post_status = 'private';" | grep -v '*' | awk '{ printf "private:%s ", $1 }'
echo ""
