#Pyg Latin, resumo de sua funcao

pyg = 'ay'										#Variavel de mudanca de palavras

original = raw_input('Enter a word:')			#Definimos uma variavel para interessao com o usuario

if len(original) > 0 and original.isalpha():	#Contamos a quantidade de caracter e testamos o que foi digitado pelo usuario foi somente letras
    word = original.lower()						#Deixamos todas as letras em caixa baixa
    first = word[0]								#Capturamos a primeira letra da palvra digitada
    new_word = word + first + pyg				#Concatenamos uma nova palavra juntando em ordem as variaveis
    new_word = new_word[1:]						#Da nova palavra removemos a primera letra e lemos somente apartir da segunda
    print original								#Imprime a palavra original digitada pelo usuario
    print new_word								#Imprime a nova palavra
else:											#Se houver qualquer outro caracter na digitacao do usuario, será imprimido a resposta empty de vazio
    print 'empty'								#Imprime 'empty' caso o usuarios digite alguma coisa alem de letras
