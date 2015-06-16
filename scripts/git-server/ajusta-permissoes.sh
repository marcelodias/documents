#!/bin/bash
# 
#   Grupo MagnetWorks  - www.magnetworks.com.br
#             noc@magnetworks.com.br
#
#  Script para ajustar permissões SGID nos repo
##
export PATH="/bin:/usr/bin:/usr/sbin:/sbin"

GIT_DIR="/srv/git"

for dir in $(ls -1d $GIT_DIR/*); do
    group_name=$(stat -c %G $dir )
    chgrp -R "$group_name" $dir
    chmod -R 2775 $dir
done


