#!/bin/bash
# Script para ler contar quantos pacotes estão instalados
#
# $1 - hostname
# $2 - community
# $3 - snmp version
#===========================================
# $ ./count_rpm_packages_installed.sh rufus ro-magnetworks 2c
#430

#==========================================
# OIDs
#------------------------------------------
rpmPackagesInstalledOID=.1.3.6.1.2.1.25.6.3.1.2

#==========================================
# snmp polling
#------------------------------------------
cmd=`which snmpwalk`

rpmPackagesInstalled=`$cmd -v$3 -c$2 $1 -Ovn $rpmPackagesInstalledOID | wc -l`

#==========================================
# sending results to cacti
#------------------------------------------
echo $rpmPackagesInstalled
