#!/usr/bin/env python
# Script para listar todos os canais disponiveis

import xmlrpclib 
import sys
 
SATELLITE_URL = "https://spacewalk.magnetlab.com.br/rpc/api" 
SATELLITE_LOGIN = "errata-admin" 
SATELLITE_PASSWORD = "SEGREDO" 

try:
    server = xmlrpclib.Server(SATELLITE_URL, verbose=0) 
    token = server.auth.login(SATELLITE_LOGIN, SATELLITE_PASSWORD) 
except:
    print "\tErro ao conectar ao servidor"
    sys.exit(1)

channels = server.channel.listAllChannels(token)

channelList=[]
print "Canais de Software com repositorio externo"
print "*" * 30 
for ch in channels:
    channelList.append(server.channel.software.getDetails(token,ch['label']))

for ch in channelList:
    if not int(len(ch['parent_channel_label'])):
        print "Parent Channel: " + ch['label']
        for child in channelList:
            if child['parent_channel_label'] == ch['label']:
                print "\tChild Channel: %s" %(child['label'])
        print ""

server.auth.logout(token)
