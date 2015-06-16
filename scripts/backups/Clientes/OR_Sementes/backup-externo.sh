#!/bin/bash
#
# Script de Backup MagnetWorks
#  noc@magnetwork.com.br
#
# versão v. 0.1
######################
export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

# define arquivo para informa que script esta sob rodando
PID="/var/run/backup-externo.pid"

# verifica se os programas auxiliares estao instalados
PRGS="rsync mutt date df mount umount"

#descubra o label do disco usando o comando --> blkid
DISK_LABEL="/backup-externo"

# ponto de montagem
DISK_MNT_POINT="/backup-externo"

#veja /etc/udev/rules.d/69-backup.rules 
DISK_DEVICE="/dev/backup-externo"

#define quais arquivos/diretorios serao backupeados
ARQS="/mnt/disco470/OR /etc /var/log"

#endereço de email do cliente
EMAIL_ADDR_CLIENT="EMAIL_DO_CLIENTE@DOMINIO.COM.BR"
EMAIL_ADDR_MAGNET="noc@magnetwork.com.br"

#========= FIM VARIAVEIS =============

# testa se script esta em progresso
if [ -e $PID ]; then
    echo "Backup em progresso"
    exit 1
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

# verifica se disco foi conectado
ls  $DISK_DEVICE &>/dev/null
disk_connected=$(echo $?)

# se disco foi conectado entao executa backup
if [ $disk_connected -eq 0 ]; then
    mount LABEL=$DISK_LABEL $DISK_MNT_POINT &>/dev/null

    # cheagem dupla se a montagem foi bem sucedida
    df | grep $DISK_MNT_POINT &>/dev/null
    is_mounted=$(echo $?)
    if [ $is_mounted -ne 0 ]; then
        echo "Particao nao esta montada!!! Saindo.."
        rm -f $PID
        exit 1
    fi

    echo $(date) > $DISK_MNT_POINT/timestamp-start
    rsync -aP --delete --log-file=$DISK_MNT_POINT/rsync.log $ARQS $DISK_MNT_POINT &>/dev/null
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
    mutt -s "Backup Externo realizado com sucesso em $(date "+%d-%m-%y %H:%M:%S")" "$EMAIL_ADDR_CLIENTE" < /tmp/body_mail.txt
else
    echo "Prezado cliente, " >> /tmp/body_mail.txt
    echo "Ocorreu um erro ao realizar o backup no servidor $(hostname)." >> /tmp/body_mail.txt
    echo "Por favor, entre em contato com a Magnet Tecnologia reportando o problema." >> /tmp/body_mail.txt
    echo "Essa mensagem foi encaminhada para o Departamento de TI da Magnet." >> /tmp/body_mail.txt
    echo "Obrigado." >> /tmp/body_mail.txt
    echo "MagnetWorks Tecnologia" >> /tmp/body_mail.txt
    mutt -s "Backup Externo realizado com sucesso em $(date "+%d-%m-%y %H:%M:%S")" "$EMAIL_ADDR_CLIENTE" < /tmp/body_mail.txt
    mutt -s "Backup Externo realizado com sucesso em $(date "+%d-%m-%y %H:%M:%S")" "$EMAIL_ADDR_MAGNET" < /tmp/body_mail.txt
fi
