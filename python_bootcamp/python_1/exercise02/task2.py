number = int(input("Введите число"))
backup_number = number
reversed_number = 0
if number > -1:
    while number > 0:
        digit = number % 10
        reversed_number = reversed_number * 10 + digit
        number = number // 10
    if backup_number == reversed_number:
        print('True')
    else:
        print('False')
else:
    print('False')


