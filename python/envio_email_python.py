#!/usr/bin/python
import smtplib

fromaddr = 'rapel@wavetec.com.br'
toaddrs  = 'rapel@wavetec.com.br'
msg = """From: rapel@wavetec.com.br

Hello, this is dog.
"""

print "Message length is " + repr(len(msg))

#Change according to your settings
smtp_server = 'server.wavetec.com.br'
smtp_username = 'rapel@wavetec.com.br'
smtp_password = 'rapel70'
smtp_port = '725'
smtp_do_tls = False

server = smtplib.SMTP(
host = smtp_server,
port = smtp_port,
timeout = 10 
)
server.set_debuglevel(10)
#server.starttls()
server.ehlo()
server.login(smtp_username, smtp_password)
server.sendmail(fromaddr, toaddrs, msg)
print server.quit()
