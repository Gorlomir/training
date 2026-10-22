n_str, x_str = input().split()
n = int(n_str)
x = float(x_str)

derivative = 0.0

for i in range(n, 0, -1):
    c = float(input())
    derivative += i * c * (x ** (i - 1))

input()
print(f"{derivative:.3f}")