def list_function(x):
    return x[1]

n = [3, 5, 7]
n[1] = n[1] + 3
list_function(n)
print list_function(n)
