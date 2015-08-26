#O Estudante se Torna o Professor

#Dicionario e suas Chaves
lloyd = {
    "name": "Lloyd",
    "homework": [90.0, 97.0, 75.0, 92.0],
    "quizzes": [88.0, 40.0, 94.0],
    "tests": [75.0, 90.0]
}
alice = {
    "name": "Alice",
    "homework": [100.0, 92.0, 98.0, 100.0],
    "quizzes": [82.0, 83.0, 91.0],
    "tests": [89.0, 97.0]
}
tyler = {
    "name": "Tyler",
    "homework": [0.0, 87.0, 75.0, 22.0],
    "quizzes": [0.0, 75.0, 78.0],
    "tests": [100.0, 100.0]
}

# Funcao para fazer media com numero real
def average(numbers):
    total = sum(numbers)
    return float(total) / len(numbers)
  
# Funcao para fazer media ponderada de cada solicitacao  
def get_average(student):
    homework = average(student["homework"])
    quizzes = average(student["quizzes"])
    tests = average(student["tests"])
    
    return ((0.1 * homework) + (0.3 * quizzes) + (0.6 * tests))

#Funcao para responder ao Aluno em String A, B, C, D ou F    
def get_letter_grade(score):
    if score >= 90:
        return "A"
    elif score >= 80:
        return "B"
    elif score >= 70:
        return "C"
    elif score >= 60:
        return "D"
    else:
        return "F"
# Mostragem de resultados de cada aluno
#print get_letter_grade(get_average(lloyd))
#print get_letter_grade(get_average(alice))
#print get_letter_grade(get_average(tyler))

# Calcular media da classe
def get_class_average(students):
    results = []
    for aluno in students:
        results.append(get_average(aluno))
    return average(results) 													# return sempre na linha do for!!!
print get_class_average(students = [lloyd, alice, tyler])						# print da media da classe em valor, linha raiz
print get_letter_grade(get_class_average(students = [lloyd, alice, tyler]))		# print da media da classe em string, linha raiz






