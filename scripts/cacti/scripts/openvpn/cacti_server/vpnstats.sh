#!/bin/bash
# Script para ler dados do OpenVPN
#
# $1 - hostname
# $2 - community
# $3 - snmp version
#===========================================
# $ ./vpnstats.sh rufus ro-magnetworks 2c
# vpnUsers:1 vpnBytesIn:643690 vpnBytesOut:878165

#==========================================
# OIDs
#------------------------------------------
vpnCustomOID=.1.3.6.1.4.1.2021.50.3.1.1.8.118.112.110.115.116.97.116.115

#==========================================
# snmp polling
#------------------------------------------
cmd=`which snmpget`

vpnUsers=`$cmd -v$3 -c $2 $1 -Ovn $vpnCustomOID | awk -F":" '{print $2}' |awk '{print $1}' | sed 's/"//g'`
vpnBytesIn=`$cmd -v$3 -c $2 $1 -Ovn $vpnCustomOID | awk -F":" '{print $2}' |awk '{print $2}' | sed 's/"//g'`
vpnBytesOut=`$cmd -v$3 -c $2 $1 -Ovn $vpnCustomOID | awk -F":" '{print $2}' |awk '{print $3}' | sed 's/"//g'`

#==========================================
# sending results to cacti
#------------------------------------------
echo vpnUsers:$vpnUsers vpnBytesIn:$vpnBytesIn vpnBytesOut:$vpnBytesOut
