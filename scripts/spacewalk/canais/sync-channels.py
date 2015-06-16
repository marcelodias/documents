#!/usr/bin/env python
# Script para listar todos os canais disponiveis

import xmlrpclib 
import sys
import subprocess
import time
 
SATELLITE_URL = "https://rufus.magnetworks.com.br/rpc/api" 
SATELLITE_LOGIN = "errata-admin" 
SATELLITE_PASSWORD = "**" 

try:
    server = xmlrpclib.Server(SATELLITE_URL, verbose=0) 
    token = server.auth.login(SATELLITE_LOGIN, SATELLITE_PASSWORD) 
except:
    print "\tErro ao conectar ao servidor"
    sys.exit(1)

channels = server.channel.listAllChannels(token)

channelList=[]
for ch in channels:
    channelList.append(server.channel.software.getDetails(token,ch['label']))

for ch in channelList:
    if int(len(ch['contentSources'])):
    	subprocess.call(['/usr/bin/spacewalk-repo-sync', '-c', ch['label'], '-t', 'yum'])
    	time.sleep(10)

server.auth.logout(token)
