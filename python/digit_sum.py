def digit_sum(n):
    results = 0
    for i in str(n):
        print i
        results += int(i)
    print results
    return results
