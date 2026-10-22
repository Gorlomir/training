#!/bin/bash

cleanup_by_date() {
    echo "Введите время начала (формат: YYYY-MM-DD HH:MM):"
    read start_time
    echo "Введите время окончания (формат: YYYY-MM-DD HH:MM):"
    read end_time

    # Преобразуем время в timestamp
    local start_ts=$(date -d "$start_time" +%s 2>/dev/null)
    local end_ts=$(date -d "$end_time" +%s 2>/dev/null)

    # Проверяем формат
    if [ -z "$start_ts" ] || [ -z "$end_ts" ]; then
        echo "Ошибка: Неверный формат даты/времени!"
        echo "Используйте формат: 'YYYY-MM-DD HH:MM'"
        return 1
    fi

    if [ $start_ts -gt $end_ts ]; then
        echo "Ошибка: Время начала не может быть позже времени окончания!"
        return 1
    fi

    echo "Поиск файлов и папок, созданных с $start_time по $end_time"

    local temp_files="/tmp/cleanup_files_$$.txt"
    local temp_dirs="/tmp/cleanup_dirs_$$.txt"

    > "$temp_files"
    > "$temp_dirs"

    echo "Поиск папок..."
    find / -type d -name "*_[0-9][0-9][0-9][0-9][0-9][0-9]" 2>/dev/null | while read dir; do
        local dir_ctime=$(stat -c %Y "$dir" 2>/dev/null)
        if [ -n "$dir_ctime" ] && [ $dir_ctime -ge $start_ts ] && [ $dir_ctime -le $end_ts ]; then
            echo "$dir" >> "$temp_dirs"
        fi
    done

    echo "Поиск файлов..."
    find / -type f -name "*_[0-9][0-9][0-9][0-9][0-9][0-9].*" 2>/dev/null | while read file; do
        local file_ctime=$(stat -c %Y "$file" 2>/dev/null)
        if [ -n "$file_ctime" ] && [ $file_ctime -ge $start_ts ] && [ $file_ctime -le $end_ts ]; then
            echo "$file" >> "$temp_files"
        fi
    done

    local files_count=$(wc -l < "$temp_files" 2>/dev/null || echo 0)
    local dirs_count=$(wc -l < "$temp_dirs" 2>/dev/null || echo 0)

    if [ $files_count -eq 0 ] && [ $dirs_count -eq 0 ]; then
        echo "Ничего не найдено для удаления."
        rm -f "$temp_files" "$temp_dirs"
        return 0
    fi

    print_stats "$files_count" "$dirs_count"

    if [ $files_count -gt 0 ]; then
        echo ""
        echo "Примеры найденных файлов:"
        head -10 "$temp_files" | sed 's/^/  /'
        if [ $files_count -gt 10 ]; then
            echo "  ... и еще $((files_count - 10)) файлов"
        fi
    fi

    if [ $dirs_count -gt 0 ]; then
        echo ""
        echo "Примеры найденных папок:"
        head -10 "$temp_dirs" | sed 's/^/  /'
        if [ $dirs_count -gt 10 ]; then
            echo "  ... и еще $((dirs_count - 10)) папок"
        fi
    fi

    confirm_action

    # Удаляем
    echo ""
    echo "Удаление файлов..."
    local deleted_files=$(delete_files "$temp_files")

    echo "Удаление папок..."
    local deleted_dirs=$(delete_dirs "$temp_dirs")

    echo ""
    echo "Удаление завершено!"
    echo "Удалено файлов: $deleted_files"
    echo "Удалено папок: $deleted_dirs"

    # Очищаем временные файлы
    rm -f "$temp_files" "$temp_dirs"
}
