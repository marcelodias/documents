def censor(text, word):
	censurado = ""
	for i in text.split():
		if i == word:
			censurado += "*" * len(i)
    	return censurado
		print censurado
    else:
        print "".join(censurado)
censor("Este e um teste hack", "hack")
