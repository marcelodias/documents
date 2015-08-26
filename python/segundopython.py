#!/usr/bin/env python
#Armazenando em arquivo leitura fibonacci
arq = open('fibonacci.txt', 'w')

f1 = 1
f2 = 1

proximo = f1 + f2

while (proximo <= 10000):
  print >> arq, proximo		#note que o >> envia a saida do print para arq
  f1      = f2
  f2      = proximo
  proximo = f1 + f2  
arq.close()
