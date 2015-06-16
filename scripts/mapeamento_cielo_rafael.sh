#!/bin/sh
# 
# Script de mapeamento das pastas da Cielo
# 
#	Marcelo Trindade Dias
#
#	versao v 0.3
############################################

export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

#============Inicio Variaveis============#

# Define arquivo para informar que script está sob o Process
PID="/var/run/mount_cielo.pid"

# Verificarse os programas auxiliares estão instalado
PRGS="mount"

# Pontos de Montagem DC
TEMP="/home/rafael.rodrigues/DC/Temp"
DADOS="/home/rafael.rodrigues/DC/Dados"
MANUAIS="/home/rafael.rodrigues/DC/Manuais"
USUARIOS="/home/rafael.rodrigues/DC/Usuarios"
SISTEMAS="/home/rafael.rodrigues/DC/Sistemas"
INSTALACOES="/home/rafael.rodrigues/DC/Instalacoes"
COMPARTILHADO="/home/rafael.rodrigues/DC/Compartilhado"

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
ROUTE_VALID="192.168.138.0   0.0.0.0         255.255.255.0   U     1      0        0 eth0"

# Informacoes User
echo "Qual seu username:"
read USER
echo "Qual sua senha"
read PWD
DOMAIN="intranet.cielo.ind.br"
RWX="0777"
#============FIM VARIAVEIS============#

# testa se script esta em progresso
if [ -e $PID ]; then
    echo "Mapeamento em progresso"
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

		umount /home/rafael.rodrigues/DC/Temp
		umount /home/rafael.rodrigues/DC/Compartilhado
		umount /home/rafael.rodrigues/DC/Dados
		umount /home/rafael.rodrigues/DC/Instalacoes
		umount /home/rafael.rodrigues/DC/Manuais
		umount /home/rafael.rodrigues/DC/Sistemas
		umount /home/rafael.rodrigues/DC/Usuarios
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

	
else
	echo "Nao foi possível montar unidades cadastradas"
	rm -f $PID
	exit 1
fi
