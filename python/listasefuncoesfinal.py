"""
Crie uma função chamada flatten que toma uma única lista e concatena todas as sublistas que são parte dela em uma única lista.

1- Na linha 3, defina uma função chamada flatten com um argumento chamado lists.
2- Crie uma nova lista vazia chamada results.
3- Percorra lists. Chame a variável de laço numbers.
4- Percorra numbers.
5- Adicione (.append()) cada número a results.
6- Finalmente, retorne results da sua função.
"""
n = [[1, 2, 3], [4, 5, 6, 7, 8, 9]]

def flatten(lists):
    results = []
    for numbers in range(0, len(lists)):
        results += lists[numbers]
    return results
print flatten(n)
