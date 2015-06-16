#!/bin/bash
#
# Script para importar errata do CentOS no Spacewalk
####
export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

# Define data
DATE=$(date +"%Y-%B")
# Define dir do links usados para tracking to Centos Errata
LINKS_DIR="/var/satellite/errata-centOS-links"

# Cria SymLinks
for file in $(find /var/satellite/redhat -type f -iname "*rpm")
  do
      filename=$(basename $file)
      if [ ! -L $LINKS_DIR/$filename ]; then
	 ln -s $file $LINKS_DIR
      fi 
  done

# Baixar as mensagens de Digest
mkdir -p /etc/spacewalk-errata
rm -f /etc/spacewalk-errata/$DATE.txt*
wget -t 2 -O /etc/spacewalk-errata/$DATE.txt.gz http://lists.centos.org/pipermail/centos-announce/$DATE.txt.gz 
gunzip -f /etc/spacewalk-errata/$DATE.txt.gz

# Processa Errata
cd /root/bin
/root/bin/centos_errata.py --password="**" -f archive /etc/spacewalk-errata/$DATE.txt -c /etc/spacewalk-errata/centos-errata.cfg >> /var/log/centos-errata.log
