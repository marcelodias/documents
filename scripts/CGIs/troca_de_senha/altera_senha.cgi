#!/usr/bin/env python
#-*- coding:utf-8 -*-
#
# Altera a senha LDAP via WEB
# versão: 1.0 (06/03/2012) - mmello@magnetworks.com.br
#=============================================

print "Content-type: text/html"
print ""

print """
<html>
<title>Troca de Senha</title>
<body>

<h2><center>Altere sua senha</center></h2>
<hr><br>

<form method="post" action="process.cgi">

<table border="0">
<tr>
<td><b>Nome:</b></td>
<td><input type="text" name="username"></td>
</tr>

<tr>
<td><b>Senha Antiga:</b></td>
<td><input type="password" name="old_pass"></td>
</tr>

<tr>
<td><b>Nova Senha:</b></td>
<td><input type="password" name="new_pass"></td>
</tr>

<tr>
<td><b>Repita Senha:</b></td>
<td><input type="password" name="new_pass2"></td>
</tr>

<tr>
<td colspan="2" align="right"> <input type="submit" value="Trocar Senha"> </td>
</tr>
</form>
</table>

<br>
<hr>
<p align="right"><img src="http://www.magnetworks.com.br/site/wp-content/uploads/2012/03/magnet_logo.png" width="26"> Desenvolvido por Magnet Tecnologia - <a href="http://www.magnetworks.com.br" target="_blank">http://www.magnetworks.com.br</a></p>

</body></html>
"""

