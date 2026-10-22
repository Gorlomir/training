#!/bin/bash
# Функция для генерации имени папки из заданных букв
generate_folder_name() {
    local letters=$1
    local min_length=4
    local name=""
    name=$letters

    local extra_chars=$((RANDOM % 10 + 5))

    local current_length=${#name}
    local target_length=$((min_length + extra_chars))

    while [ $current_length -lt $target_length ]; do
        local random_index=$((RANDOM % ${#letters}))
        name="${name}${letters:$random_index:1}"
        current_length=$((current_length + 1))
    done

    echo "$name"
}

# Функция для генерации имени файла
generate_file_name() {
    local name_part=$1
    local min_length=4
    local name=""

    name=$name_part

    local extra_chars=$((RANDOM % 10 + 5))

    # Добавляем случайные буквы
    local current_length=${#name}
    local target_length=$((min_length + extra_chars))

    while [ $current_length -lt $target_length ]; do
        local random_index=$((RANDOM % ${#name_part}))
        name="${name}${name_part:$random_index:1}"
        current_length=$((current_length + 1))
    done
    
    echo "$name"
}
# Функция проверки свободного места
check_free_space() {
    local free_space=$(df / | tail -1 | awk '{print $4}')
    local free_space_mb=$((free_space / 1024))
    
    if [ $free_space_mb -lt 1024 ]; then
        echo "Ошибка: Осталось менее 1 ГБ свободного места. Скрипт остановлен."
        exit 1
    fi
}
write_log() {
    local log_file=$1
    local log_entry=$2
    echo "$log_entry" >> "$log_file"
}
