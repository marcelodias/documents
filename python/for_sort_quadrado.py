start_list = [5, 3, 1, 2, 4]
square_list = []

for list in start_list:
    quadrado = list ** 2
    square_list.append(quadrado)
square_list.sort()

print square_list
