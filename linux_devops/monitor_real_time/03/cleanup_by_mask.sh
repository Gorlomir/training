#!/bin/bash

cleanup_by_mask() {
    local mask=$1

    if [[ ! "$mask" =~ ^[a-zA-Z]+_[0-9]{6}$ ]]; then
        echo "Ошибка: Неверный формат маски!"
        echo "Маска должна быть в формате: буквы_дата (например: az_120325)"
        echo "Где дата: ДДММГГ"
        return 1
    fi

    echo "Поиск файлов и папок по маске: $mask"

    # Извлекаем имя и дату из маски
    local name_part=$(echo "$mask" | cut -d'_' -f1)
    local date_part=$(echo "$mask" | cut -d'_' -f2)

    # Временные файлы
    local temp_files="/tmp/cleanup_files_$$.txt"
    local temp_dirs="/tmp/cleanup_dirs_$$.txt"

    > "$temp_files"
    > "$temp_dirs"

    # Поиск папок
    echo "Поиск папок..."
    find / -type d -name "${name_part}*_${date_part}" 2>/dev/null | while read dir; do
        echo "$dir" >> "$temp_dirs"
    done

    # Поиск файлов
    echo "Поиск файлов..."
    find / -type f -name "${name_part}*_${date_part}.*" 2>/dev/null | while read file; do
        echo "$file" >> "$temp_files"
    done

    # Подсчитываем количество
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
        echo "Найденные файлы:"
        cat "$temp_files" | sed 's/^/  /'
    fi

    if [ $dirs_count -gt 0 ]; then
        echo ""
        echo "Найденные папки:"
        cat "$temp_dirs" | sed 's/^/  /'
    fi

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

    # Очищаем временные файлы
    rm -f "$temp_files" "$temp_dirs"
}

