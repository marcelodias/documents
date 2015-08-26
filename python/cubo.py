def cube(number):
    return number**3
    
def by_three(number):
    if number % 3 == 0:
        return cube(number)
        print "Numero divisivel por 3"
    else:
        print "Numero nao divisivel por 3"
        return False