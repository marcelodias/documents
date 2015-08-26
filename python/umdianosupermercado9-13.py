prices = {
    "banana" : 4,
    "maca"  : 2,
    "laranja" : 1.5,
    "pera"   : 3,
}
stock = {
    "banana" : 6,
    "maca"  : 0,
    "laranja" : 32,
    "pera"   : 15,
}

total = 0
for key in prices:
    print key
    print "price: %s" % prices[key]
    print "stock: %s" % stock[key]
    for soma in stock:
        if key == soma:
            total += prices[key] * stock[soma]
print total
