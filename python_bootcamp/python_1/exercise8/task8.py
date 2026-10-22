N = int(input())
numbers = [int(input()) for _ in range(N)]
uniq_num = len(set(numbers))
print(uniq_num)
