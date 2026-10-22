#!/bin/bash
mkdir -p nginx
. ./generate.sh
response_base=(200 201 400 401 403 404 500 501 502 503) # 2хх(всё четко):
							# 200 - всё гуд ответ получен
							# 201 - Created, ресурс создан (например, POST-запрос)
							# 4xx(error)
							# 400 — Bad Request, сервер не понял запрос (неверный синтаксис)
							# 401 — Unauthorized, требуется авторизация
							# 403 — Forbidden, доступ запрещён (авторизация есть, но прав нет)
							# 404 — Not Found, ресурс не найден
							# 5xx(error server)
							# 500 — Internal Server Error, внутренняя ошибка сервера
							# 501 — Not Implemented, сервер не поддерживает требуемую функцию
							# 502 — Bad Gateway, шлюз получил неверный ответ от вышестоящего сервера
							# 503 — Service Unavailable, сервер временно недоступен (перегрузка или техработы)

methods_base=(GET POST PUT PATCH DELETE)

urls=(
    "/index.html"
    "/about.html"
    "/contact"
    "/api/v1/users"
    "/api/v1/products"
    "/images/logo.png"
    "/css/style.css"
    "/js/app.js"
    "/admin"
    "/login"
)

user_agents=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler")

# Основной цикл по дням (5 дней)
for day in {1..5}; do
    # Случайное количество записей за день от 100 до 1000
    entries=$((RANDOM % 901 + 100))
    # Имя файла лога для этого дня
    log_file="nginx/access_log_2026-03-$(printf "%02d" $day).log"
    echo "Генерация $entries записей для $log_file"
    # Массив для хранения дат записей в отсортированном виде
    # Сначала генерируем все даты для записей, затем сортируем
    dates=()
    for ((i=0; i<entries; i++)); do
        # Случайное время в пределах дня (можно сделать более реалистичное распределение)
        hour=$((RANDOM % 24))
        minute=$((RANDOM % 60))
        second=$((RANDOM % 60))
        sort_key=$(printf "%04d%02d%02d%02d%02d%02d" 2025 3 $day $hour $minute $second)
        dates+=("$sort_key|$hour|$minute|$second")
    done
    # Сортируем даты по возрастанию
    IFS=$'\n' sorted_dates=($(sort <<<"${dates[*]}"))
    unset IFS
    # Открываем файл для записи
    > "$log_file"
    # Генерируем записи в порядке возрастания дат
    for entry in "${sorted_dates[@]}"; do
        IFS='|' read -r sort_key hour minute second <<< "$entry"
        # Формируем строку даты
        datetime=$(printf "%02d/Mar/2026:%02d:%02d:%02d +0000" "$day" "$hour" "$minute" "$second")

        ip=$(generate_ip)
        method=$(random_method)
        url=$(random_url)
        response=$(random_response)
        user_agent=$(random_user_agent)

        # Размер ответа (случайный от 100 до 10000 байт)
        bytes=$((RANDOM % 9901 + 100))
        # Формат combined: IP - - [дата] "метод URL HTTP/1.1" код размер "-" "агент"
        echo "$ip - - [$datetime] \"$method $url HTTP/1.1\" $response $bytes \"-\" \"$user_agent\"" >> "$log_file"
    done

    echo "Лог сохранён в $log_file"
done

