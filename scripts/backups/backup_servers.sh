#!/bin/bash
#
# Script de Backup Marcelo Dias 
#  marcelo.dias@grupocielo.com.br
#
# versão v. 0.1
######################
export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

# define arquivo para informa que script esta sob rodando
PID="/var/run/backup-externo.pid"

# verifica se os programas auxiliares estao instalados
PRGS="rsync mutt date df mount umount"

# ponto de montagem
DISK_MNT_POINT="/backup_online"

# Teste se o IP está UP 
IP_STORAGE="192.168.138.21"

#define quais arquivos/diretorios serao backupeados
ARQS="/etc /var"

#endereço de email do cliente
EMAIL_ADDR_MDIAS="marcelo.dias@grupocielo.com.br"

#========= FIM VARIAVEIS =============

# testa se script esta em progresso
if [ -e $PID ]; then
     echo "Backup em progresso"
#     exit 1
 else
     touch $PID &>/dev/null
     if [ ! -e $PID ]; then
         echo "Erro ao gravar arquivo $PID. Abortando backup"
         exit 1
     fi
fi
 
# verifica se os comandos utilizados estao presentes
for comando in $PRGS
    do
        if [ ! -e $(which $comando) ]; then
            echo "$comando nao foi encontrado. Instale o comando $comando"
            rm -f $PID
            exit 1
        fi
    done
 
# verifica se IP está online
ping -c 1 $IP_STORAGE | grep icmp_seq=1 | cut -c28 > $PID
	VRF=`while read LN; do echo $LN ; done < $PID`
	if [ $VRF == 1 ] ; then
	echo Falha de Conexão com o Servidor
	echo Verifique se há conectividade de rede local, ou se o servidor responde a conexões
	else if [ -e /backup_online/FW1B ]; then

# se disco externo foi conectado entao executa backup
if [ $ip_connected -eq 0 ]; then
    mount -t cifs //192.168.138.21/Backups /backup_online  -o username=backup.rede,domain=INTRANET,passwrd=WebC1el0,iocharset=utf8,users,file_mode=rwx,dir_mode=rwx
  &>/dev/null


    # cheagem dupla se a montagem foi bem sucedida
    df | grep $DISK_MNT_POINT &>/dev/null
    if [ $is_mounted -ne 0 ]; then
        echo "Particao nao esta montada!!! Saindo.."
        rm -f $PID
        exit 1
    fi

    echo $(date) > $DISK_MNT_POINT/timestamp-start
    rsync -Cravp --delete --log-file=$DISK_MNT_POINT/rsync.log $ARQS $DISK_MNT_POINT &>/dev/null
    rsync_code=$(echo $?)
    echo $(date) > $DISK_MNT_POINT/timestamp-stop

    # desmonta o disco
    umount  $DISK_MNT_POINT

    # apaga arquivo de PID pois backup terminou
    rm -f $PID
else
    echo "O disco externo nao foi encontrado!!"
    echo "O backup nao foi executado"
    rm -f $PID
    exit 1
fi
 
# man rsync 
# EXIT CODES
#       0      Success
#       24     Partial transfer due to vanished source files
#------------------------------------------------------------

### envia email
rm -f /tmp/body_mail.txt
if [ $rsync_code -eq 0 ] || [ $rsync_code -eq 24 ]; then
    echo "Prezado cliente, " >> /tmp/body_mail.txt
    echo "O backup no servidor $(hostname) foi realizado com sucesso." >> /tmp/body_mail.txt
    echo "Por favor, remova o HD externo." >> /tmp/body_mail.txt
    echo "Obrigado."  >> /tmp/body_mail.txt
    echo "MagnetWorks Tecnologia" >> /tmp/body_mail.txt
    mutt -s "Backup Externo realizado com sucesso em $(date "+%d-%m-%y %H:%M:%S")" "$EMAIL_ADDR_MDIAS" < /tmp/body_mail.txt
else
    echo "Prezado cliente, " >> /tmp/body_mail.txt
    echo "Ocorreu um erro ao realizar o backup no servidor $(hostname)." >> /tmp/body_mail.txt
    echo "Por favor, entre em contato com a Magnet Tecnologia reportando o problema." >> /tmp/body_mail.txt
    echo "Essa mensagem foi encaminhada para o Departamento de TI da Magnet. " >> /tmp/body_mail.txt
    echo "Obrigado." >> /tmp/body_mail.txt
    echo "MagnetWorks Tecnologia" >> /tmp/body_mail.txt
    mutt -s "Backup Externo realizado com sucesso em $(date "+%d-%m-%y %H:%M:%S")" "$EMAIL_ADDR_MDIAS" < /tmp/body_mail.txt
#    mutt -s "Backup Externo realizado com sucesso em $(date "+%d-%m-%y %H:%M:%S")" "$EMAIL_ADDR_MAGNET" < /tmp/body_mail.txt
fi

