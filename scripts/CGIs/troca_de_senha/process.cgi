#!/usr/bin/env python
#-*- coding:utf-8 -*- 
#
# Altera a senha LDAP via WEB
# versão: 1.1 (01/04/2012) - mmello@magnetworks.com.br
# - leitura a partir do /etc/openldap/ldap.conf
#
# versão: 1.0 (06/03/2012) - mmello@magnetworks.com.br
#=============================================
# Configuração (deprecated)
#LDAP_URI="ldap://ldap.meuclientefavorito.com.br:389"
#LDAP_BASE="dc=meuclientefavorito,dc=com,dc=br"
#---------------------
LDAP_USERS_OU="ou=People"
##################################
import cgi
import cgitb; cgitb.enable() 
import sys
import os
import string,base64,random
import hashlib
from base64 import encodestring as encode
from base64 import decodestring as decode

print "Content-Type: text/html\n"
print '<html><body>'

try:
    ldapconf = open("/etc/openldap/ldap.conf", "r").readlines()
    KEYWORDS = ['URI', 'BASE']
    for line in ldapconf:
        for info in KEYWORDS:
            if line.startswith(info):
                if info == "URI":
                    LDAP_URI=line.split()[1] + ":389"
                else:
                    LDAP_BASE=line.split()[1]
except:
    print "Configuração não encontrada!!!!!"
    sys.exit(1)

# importa python-ldap
try:
    import ldap
except:
    print "<br><b>Erro ao importar módulo ldap!!</b> Dica:"
    print "<br><pre>$ yum install python-ldap</pre>"
    sys.exit(1)

# importa python-smbpasswd
try:
    import smbpasswd
except:
    print "<br><b>Erro ao importar módulo smbpasswd!!</b> Dica:"
    print "<br><pre>$ yum install python-smbpasswd</pre>"
    sys.exit(1)

def ssha_hashPassword(password):
    salt = os.urandom(4)
    h = hashlib.sha1(password)
    h.update(salt)
    return "{SSHA}" + encode(h.digest() + salt)[:-1]

form = cgi.FieldStorage()

# cria dict
form_values = { 'username' : '', 'old_pass': '', 'new_pass': '', 'new_pass2': ''}

# atribue valores
form_values['username']  = form.getvalue('username', '')
form_values['old_pass']  = form.getvalue('old_pass', '')
form_values['new_pass']  = form.getvalue('new_pass', '')
form_values['new_pass2'] = form.getvalue('new_pass2','')

# testa se algum campo ficou em branco
for chave, valor in form_values.items():
    if not valor:
        print "<br><h2>Erro!! Preencha todos os campos na página anterior.</h2>" 
        print "<INPUT TYPE='button' VALUE='Voltar' onClick='history.go(-1);'>"
        sys.exit(1)

# testa se as senhas são iguais
if form_values['new_pass'] != form_values['new_pass2']:
    print "<br><h2>Erro!! As novas senhas precisam ser iguais!!</h2>" 
    print "<INPUT TYPE='button' VALUE='Voltar' onClick='history.go(-1);'>"
    sys.exit(1)


# testa se novas senhas são iguais a antiga
if ((form_values['new_pass'] == form_values['old_pass']) or (form_values['new_pass2'] == form_values['old_pass'])):
    print "<br><h2>Erro!! Nova senha igual a senha antiga. Por favor, escolha uma senha diferente!!</h2>" 
    print "<INPUT TYPE='button' VALUE='Voltar' onClick='history.go(-1);'>"
    sys.exit(1)

#ldap
binddn = "uid=" + form_values['username'] + "," + LDAP_USERS_OU + "," + LDAP_BASE
bindpw = form_values['old_pass']
try:
    conn = ldap.initialize(LDAP_URI, trace_level=0)
    conn.simple_bind_s(binddn, bindpw)
except ldap.INVALID_CREDENTIALS:
    print "<br><h2>Erro!! Usuário e/ou senha errada.</h2>"
    print "<INPUT TYPE='button' VALUE='Voltar' onClick='history.go(-1);'>"
    sys.exit(1)
except ldap.LDAPError, e:
    print "<br><h2>Erro!! Usuário e/ou senha errada.</h2>"
    print "<INPUT TYPE='button' VALUE='Voltar' onClick='history.go(-1);'>"
    sys.exit(1)


# alterar senha
ldif = []
ldif.append((ldap.MOD_REPLACE,"userPassword",ssha_hashPassword(form_values['new_pass'])))
ldif.append((ldap.MOD_REPLACE,"sambaLMPassword",smbpasswd.lmhash(form_values['new_pass'])))
ldif.append((ldap.MOD_REPLACE,"sambaNTPassword",smbpasswd.nthash(form_values['new_pass'])))

try:
    conn.modify_s(binddn,ldif)
    print "<br><h2>Parabéns!!<br></h2>"
    print "<h3>Senha do usuário <font color='blue'>%s</font> alterada com sucesso!!!</h3>" %(form_values['username'])
    conn.unbind_s()
except ldap.LDAPError, e:
    print "<br><h2>Erro ao conectar no servidor LDAP</h2>"
    print "Info: %s" %(e.args)
    sys.exit(1)

print '</body></html>'
