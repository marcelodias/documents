prices = {
    "banana": 4,
    "maca": 2,
    "laranja": 1.5,
    "pera": 3
}
stock = {
    "banana": 6,
    "maca": 0,
    "laranja": 32,
    "pera": 15
}
for precos in prices:
    print precos
    print "price: %s" % prices[precos]
    print "stock: %s" % stock[precos]
