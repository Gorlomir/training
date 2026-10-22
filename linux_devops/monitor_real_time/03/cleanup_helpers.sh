#!/bin/bash

confirm_action() {
    echo -n "Вы уверены, что хотите удалить? (y/n): "
    read answer
    if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
        echo "Операция отменена."
        exit 0
    fi
}

delete_files() {
    local file_list=$1
    local deleted=0

    while read file; do
        if [ -n "$file" ] && rm -f "$file" 2>/dev/null; then
            echo "Удален файл: $file"
            ((deleted++))
        elif [ -n "$file" ]; then
            echo "Не удалось удалить файл: $file"
        fi
    done < "$file_list"

    echo "$deleted"
}

delete_dirs() {
    local dir_list=$1
    local deleted=0

    sort -r "$dir_list" | while read dir; do
        if [ -n "$dir" ] && rm -rf "$dir" 2>/dev/null; then
            echo "Удалена папка: $dir"
            ((deleted++))
        elif [ -n "$dir" ]; then
            echo "Не удалось удалить папку: $dir"
        fi
    done

    echo "$deleted"
}

print_stats() {
    local files_count=$1
    local dirs_count=$2
    echo ""
    echo "Найдено для удаления:"
    echo "  Файлов: $files_count"
    echo "  Папок: $dirs_count"
}
