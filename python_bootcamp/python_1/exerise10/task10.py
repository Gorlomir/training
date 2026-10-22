def find_min_cost(N, total_time, appliances):
    try:
        appliances_by_year = {}
        for year, cost, time in appliances:
            if year not in appliances_by_year:
                appliances_by_year[year] = []
            appliances_by_year[year].append((cost, time))

        min_cost = float('inf')
        for year in appliances_by_year:
            devices = appliances_by_year[year]
            n = len(devices)
            for i in range(n):
                for j in range(i + 1, n):
                    cost1, time1 = devices[i]
                    cost2, time2 = devices[j]
                    if time1 + time2 == total_time:
                        min_cost = min(min_cost, cost1 + cost2)

        if min_cost == float('inf'):
            return "Ошибка ввода"
        else:
            return min_cost

    except Exception:
        return "Ошибка ввода"


if __name__ == "__main__":
    try:
        first_line = input().strip()
        if not first_line:
            print("Ошибка ввода")
            exit()

        N, total_time = map(int, first_line.split())

        if N < 2 or total_time <= 0:
            print("Ошибка ввода")
            exit()

        appliances = []
        for _ in range(N):
            line = input().strip()
            if not line:
                print("Ошибка ввода")
                exit()

            year, cost, time = map(int, line.split())

            if year <= 0 or cost <= 0 or time <= 0:
                print("Ошибка ввода")
                exit()

            appliances.append((year, cost, time))

        result = find_min_cost(N, total_time, appliances)
        print(result)

    except (ValueError, EOFError):
        print("Ошибка ввода")