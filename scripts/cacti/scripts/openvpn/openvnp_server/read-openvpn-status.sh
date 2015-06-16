#!/bin/bash
#
# Autor: Andre Zenun
# Descricao: Envia utilizando o agente SNMP informacoes sobre usuarios
#            e o trafego gerado por eles.
#
# Fonte: http://andrezenun.blogspot.com/2008/09/openvpn-grafico-de-usuarios-conectados.html
#-----------------------------------------------------------------------------------------------
#
#  Instalando script
#
#   $ mkdir -p /etc/snmp/scripts
#   $ cp read-openvpn-status.sh  /etc/snmp/scripts
#
#   $ vim /etc/snmp/snmpd.conf
#   extend .1.3.6.1.4.1.2021.50 vpnstats /bin/bash /etc/snmp/scripts/read-openvpn-status.sh 
#
#   $ service snmpd restart
#   $ snmpwalk  -v 2c -c <COMMUNITY> <HOST> -On .1.3.6.1.4.1.2021.50
#   .1.3.6.1.4.1.2021.50.1.0 = INTEGER: 1
#   .1.3.6.1.4.1.2021.50.2.1.2.8.118.112.110.115.116.97.116.115 = STRING: "/bin/bash"
#   .1.3.6.1.4.1.2021.50.2.1.3.8.118.112.110.115.116.97.116.115 = STRING: "/etc/snmp/scripts/read-openvpn-status.sh"
#   .1.3.6.1.4.1.2021.50.2.1.4.8.118.112.110.115.116.97.116.115 = ""
#   .1.3.6.1.4.1.2021.50.2.1.5.8.118.112.110.115.116.97.116.115 = INTEGER: 5
#   .1.3.6.1.4.1.2021.50.2.1.6.8.118.112.110.115.116.97.116.115 = INTEGER: 1
#   .1.3.6.1.4.1.2021.50.2.1.7.8.118.112.110.115.116.97.116.115 = INTEGER: 1
#   .1.3.6.1.4.1.2021.50.2.1.20.8.118.112.110.115.116.97.116.115 = INTEGER: 4
#   .1.3.6.1.4.1.2021.50.2.1.21.8.118.112.110.115.116.97.116.115 = INTEGER: 1
#   .1.3.6.1.4.1.2021.50.3.1.1.8.118.112.110.115.116.97.116.115 = STRING: "1 412877 472685"
#   .1.3.6.1.4.1.2021.50.3.1.2.8.118.112.110.115.116.97.116.115 = STRING: "1 412877 472685"
#   .1.3.6.1.4.1.2021.50.3.1.3.8.118.112.110.115.116.97.116.115 = INTEGER: 1
#   .1.3.6.1.4.1.2021.50.3.1.4.8.118.112.110.115.116.97.116.115 = INTEGER: 0
#   .1.3.6.1.4.1.2021.50.4.1.2.8.118.112.110.115.116.97.116.115.1 = STRING: "1 412877 472685"
#
#=============================================================
# variaveis
#-------------------------------------------------------------
OPENVPN_STATS="/etc/openvpn/rufus-status.log"
CMD_AWK=`which awk`
CMD_CAT=`which cat`
CMD_WC=`which wc`
CMD_SUDO=`which sudo`
CMD_EGREP=`which egrep`

#=============================================================
# variaveis auxiliares
#-------------------------------------------------------------
bytesRecTot=0
bytesSenTot=0
num=0

#=============================================================
# aquisicao de informacoes
#-------------------------------------------------------------
#vpn_info=`$CMD_SUDO $CMD_EGREP '^[a-z]' $OPENVPN_STATS | $CMD_AWK -F, '{print $3";"$4}'`
## removendo sudo pois SNMP roda como root
vpn_info=`$CMD_EGREP '^[a-z]' $OPENVPN_STATS | $CMD_AWK -F, '{print $3";"$4}'`

for i in $vpn_info
do
        bytesReceived=`echo $i | awk -F";" '{print $1}'`
        bytesSent=`echo $i | awk -F";" '{print $2}'`

        let "bytesRecTot=$bytesRecTot+$bytesReceived"
        let "bytesSenTot=$bytesSenTot+$bytesSent"
        let "num=$num+1"
done

#=============================================================
# enviando informacoes para o agente snmp
#-------------------------------------------------------------
echo ${num} ${bytesRecTot} ${bytesSenTot}
