def distance_from_zero(pointzero):
    if type(pointzero) == int or type(pointzero) == float:
        return abs(pointzero)
    else:
        return "Nao"
distance_from_zero(-10)
