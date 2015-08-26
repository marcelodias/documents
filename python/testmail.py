import smtplib
fromaddr = 'rapel@wavetec.com.br'
toaddrs  = 'marcelo.incure@gmail.com'
msg = 'Why,Oh why!'
username = 'rapel@wavetec.com.br'
password = 'rapelraquelpedrozo'
server = smtplib.SMTP('server.wavetec.com.br:587')
server.starttls()
server.login(username,password)
server.sendmail(fromaddr, toaddrs, msg)
server.quit()
