try:
    N = int(input('Введите целое число: '))
    P = []
    if N > 0:
            number = int(N)
            for i in range(0, number):
                row = [1] * (i + 1)
                for j in range(i + 1):
                    if j != 0 and j != i:
                        row[j] = P[i - 1][j - 1] + P[i - 1][j]

                P.append(row)
            for r in P:
                print(r)
    else:
        print('Введенно не целое натуральное число')
except ValueError:
    print("Введите целое натуральное число!")
