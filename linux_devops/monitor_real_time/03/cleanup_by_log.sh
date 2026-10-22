#!/bin/bash

cleanup_by_log() {
    local log_file=$1

    # Проверка существования лог-файла
    if [ ! -f "$log_file" ]; then
        echo "Ошибка: Файл лога '$log_file' не найден!"
        return 1
    fi

    echo "Чтение лог-файла: $log_file"

    # Временные файлы
    local temp_files="/tmp/cleanup_files_$$.txt"
    local temp_dirs="/tmp/cleanup_dirs_$$.txt"

    > "$temp_files"
    > "$temp_dirs"

    # Парсим лог-файл
    while IFS='|' read -r type path timestamp size; do
        if [ -e "$path" ]; then
            if [ "$type" = "FILE" ]; then
                echo "$path" >> "$temp_files"
                echo "Найден файл: $path"
            elif [ "$type" = "DIR" ]; then
                echo "$path" >> "$temp_dirs"
                echo "Найдена папка: $path"
            fi
        fi
    done < "$log_file"

    # Подсчитываем количество
    local files_count=$(wc -l < "$temp_files" 2>/dev/null || echo 0)
    local dirs_count=$(wc -l < "$temp_dirs" 2>/dev/null || echo 0)

    if [ $files_count -eq 0 ] && [ $dirs_count -eq 0 ]; then
        echo "Ничего не найдено для удаления."
        rm -f "$temp_files" "$temp_dirs"
        return 0
    fi

    print_stats "$files_count" "$dirs_count"
    confirm_action

    echo ""
    echo "Удаление файлов..."
    local deleted_files=$(delete_files "$temp_files")

    echo "Удаление папок..."
    local deleted_dirs=$(delete_dirs "$temp_dirs")

    echo ""
    echo "Удаление завершено!"
    echo "Удалено файлов: $deleted_files"
    echo "Удалено папок: $deleted_dirs"

    rm -f "$temp_files" "$temp_dirs"
}
