#!/usr/bin/python 
#coding: utf-8
#
# Agente Magnet DyDNS para atualização 
#
# versão: 0.4
#################################
import sys
import urllib
import ftplib
import re
import os

FTP_SERVER="ftp2.magnetworks.com.br"
FTP_USER="dyndns"
FTP_PASSWORD="DNSIuPP"
TEMP_FILE="/tmp/magnet-dyndns.txt"
#-----------------------------

def get_customer_name(filename):
    if not os.path.isfile(filename):
        print "Arquivo %s não existe" %(filename)
        print "Execute: $ echo \"nome_do_cliente\" > %s" %(filename)
        sys.exit(1)

    fd = open(filename, "r")
    customer_name = fd.read()
    fd.close()
    return str(customer_name.split('\n')[0])

def create_file(filename, data):
    """
        Create file and store information
    """
    fd = open(filename, "w")
    fd.write(data + '\n')
    fd.close()
    return


def get_remote_ip():
    """ 
        Try to discover remote IP using external website
    """
    data = re.compile(u'(?P<ip>\d+\.\d+\.\d+\.\d+)').search(urllib.URLopener().open('http://jsonip.com/').read()).groupdict()
    return data['ip']

def upload_file(server, username, password, local_file, customer_name):
    """
        Upload file to FTP Server 
    """
    remote_string="STOR " + customer_name + "-magnet-dynDNS.txt"
    ftp = ftplib.FTP(server)
    #ftp.set_debuglevel(2)
    ftp.login(username,password)
    ftp.storbinary(remote_string, local_file)
    ftp.quit()

def main():
    """
        Send remote IP to FTP server
    """
    customer_name = get_customer_name("/etc/customer-name")
    remoteIP = get_remote_ip()
    create_file(TEMP_FILE, remoteIP)
    fd = open(TEMP_FILE, 'r')
    upload_file(FTP_SERVER, FTP_USER, FTP_PASSWORD,fd,customer_name)
    fd.close()

#========================================================
# executa script
if __name__ == '__main__':
    main()
