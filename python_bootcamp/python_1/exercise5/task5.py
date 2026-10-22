def str_to_float(s):
    s = s.strip()
    if not s:
        raise ValueError("Пустая строка")
    sign = 1
    if s[0] == '-':
        sign = -1
        s = s[1:]
    elif s[0] == '+':
        s = s[1:]
    if not s:
        raise ValueError("После знака нет цифр")
    dot_count = 0
    for ch in s:
        if ch == '.':
            dot_count += 1
        elif not ch.isdigit():
            raise ValueError(f"Недопустимый символ '{ch}'")
    if dot_count > 1:
        raise ValueError("Более одной десятичной точки")
    if not any(ch.isdigit() for ch in s):
        raise ValueError("Отсутствуют цифры")
    digits = {'0': 0, '1': 1, '2': 2, '3': 3, '4': 4,
              '5': 5, '6': 6, '7': 7, '8': 8, '9': 9}
    result = 0.0
    power = 0
    dot_found = False
    for char in s:
        if char == '.':
            dot_found = True
            continue
        val = digits[char]
        if not dot_found:
            result = result * 10 + val
        else:
            power += 1
            result += val * (10 ** -power)
    return result * sign
num_str = input()
try:
    int_num = str_to_float(num_str)
    finale_result = int_num * 2
    print(f"{finale_result:.3f}")
except ValueError as e:
    print(f"Ошибка ввода: {e}")