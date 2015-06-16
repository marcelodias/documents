#!/bin/sh
#------------------------------------------#
# Script de mapeamento das pastas da Cielo #
#	 	Marcelo Trindade Dias	   #
#		   versao v. 0.3	   #
#------------------------------------------#

export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

#============Inicio Variaveis============#

# Mostra dia e hora que foi executado
DATA="`date`"

# Log do processo de mapeamento
LOG="/home/mdias/logs/mapeamento.log"

# Define arquivo para informar que script está sob o Process
PID="/var/run/mount_cielo.pid"

# Verificarse os programas auxiliares estão instalado
PRGS="mount"

# Pontos de Montagem DC
TEMP="/mnt/DC/Temp"
DADOS="/mnt/DC/Dados"
MANUAIS="/mnt/DC/Manuais"
USUARIOS="/mnt/DC/Usuarios"
SISTEMAS="/mnt/DC/Sistemas"
INSTALACOES="/mnt/DC/Instalacoes"
COMPARTILHADO="/mnt/DC/Compartilhado"

# Pontos de Montagem Rede Interna
VIDEOS="/mnt/IRIS"
TARIS_GRAVACOES="/mnt/TARIS_GRAVACOES"
PINACULO_GRAVACOES="/mnt/PINACULO_GRAVACOES"

# Pasta da rede DC
DCTEMP="//dc/temp"
DCDADOS="//dc/dados"
DCMANUAIS="//dc/manuais"
DCSISTEMAS="//dc/sistemas"
DCUSUARIOS="//dc/usuarios"
DCINSTALACOES="//dc/instalacoes"
DCCOMPARTILHADO="//dc/compartilhado"

# Pasta de rede na Rede Interna
IRISVIDEOS="//iris/Videos"
TARGRAVACOES="//taris/Gravacoes"
PINGRAVACOES="//monitoramento12/gravacoes_pinaculo"

# Route
ROUTE=`route -n | grep -w 192.168.138.0 | awk -F: '{print $1}'`
ROUTE_VALID="192.168.138.0   0.0.0.0         255.255.255.0   U     0      0        0 p4p1"

# Informacoes User
	echo "Qual seu username:"
	read USER
	echo "Qual sua senha"
	read PWD
DOMAIN="intranet.cielo.ind.br"
RWX="0777"
#============FIM VARIAVEIS============#
# Data e hora que foi executado
	echo "$DATA"

# Gerando log
	echo " " >> $LOG
	echo "Verificando sua rota em `date`" >> $LOG
	echo "Seu PID $PID" >> $LOG
	echo "Seu computador esta na rota $ROUTE" >> $LOG
 
# testa se script esta em progresso
if [ -e $PID ]; then
    echo "Mapeamento em progresso" >> $LOG
#    exit 1
else
    touch $PID &>/dev/null
    if [ ! -e $PID ]; then
        echo "Erro ao gravar arquivo $PID. Mapeamento Abortado"
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

# Verificar qual rede esta
	if [ "$ROUTE" = "$ROUTE_VALID" ]; then
	echo "Mapeamento inciado em `date`" >> $LOG
		umount /mnt/DC/Temp
		umount /mnt/DC/Compartilhado
		umount /mnt/DC/Dados
		umount /mnt/DC/Instalacoes
		umount /mnt/DC/Manuais
		umount /mnt/DC/Sistemas
		umount /mnt/DC/Usuarios

#		umount /mnt/IRIS
#		umount /mnt/TARIS_GRAVACOES
#		umount /mnt/PINACULO_GRAVACOES

		mount -t cifs $DCTEMP $TEMP -o username=$USER,domain=$DOMAIN,password=$PWD,iocharset=utf8,users,file_mode=$RWX,dir_mode=$RWX
		mount -t cifs $DCDADOS $DADOS -o username=$USER,domain=$DOMAIN,password=$PWD,iocharset=utf8,users,file_mode=$RWX,dir_mode=$RWX
        mount -t cifs $DCMANUAIS $MANUAIS -o username=$USER,domain=$DOMAIN,password=$PWD,iocharset=utf8,users,file_mode=$RWX,dir_mode=$RWX
        mount -t cifs $DCSISTEMAS $SISTEMAS -o username=$USER,domain=$DOMAIN,password=$PWD,iocharset=utf8,users,file_mode=$RWX,dir_mode=$RWX
		mount -t cifs $DCUSUARIOS $USUARIOS -o username=$USER,domain=$DOMAIN,password=$PWD,iocharset=utf8,users,file_mode=$RWX,dir_mode=$RWX
		mount -t cifs $DCINSTALACOES $INSTALACOES -o username=$USER,domain=$DOMAIN,password=$PWD,iocharset=utf8,users,file_mode=$RWX,dir_mode=$RWX
		mount -t cifs $DCCOMPARTILHADO $COMPARTILHADO -o username=$USER,domain=$DOMAIN,passwrd=$PWD,iocharset=utf8,users,file_mode=$RWX,dir_mode=$RWX
		
#		mount -t cifs $IRISVIDEOS $VIDEOS -o username=$USER,domain=$DOMAIN,password=$PWD,iocharset=utf8,users,file_mode=$RWX,dir_mode=$RWX
#		mount -t cifs $PINGRAVACOES $PINACULO_GRAVACOES -o username=$USER,domain=$DOMAIN,password=$PWD,iocharset=utf8,users,file_mode=$RWX,dir_mode=$RWX
#       mount -t cifs $TARGRAVACOES $TARIS_GRAVACOES -o username=$USER,domain=$DOMAIN,password=$PWD,iocharset=utf8,users,file_mode=$RWX,dir_mode=$RWX
clear
else
	echo "Nao foi possível montar unidades cadastradas"
	rm -f $PID
	exit 1
fi
