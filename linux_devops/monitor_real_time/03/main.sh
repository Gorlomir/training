#!/bin/bash

. ./cleanup_helpers.sh
. ./cleanup_by_log.sh
. ./cleanup_by_date.sh
. ./cleanup_by_mask.sh

if [ $# -ne 1 ]; then
    echo "Ошибка: необходимо указать 1 параметр"
    echo "Способы очистки:"
    echo "  1 - по лог-файлу"
    echo "  2 - по дате и времени создания"
    echo "  3 - по маске имени"
    exit 1
fi

case $1 in
    1)
        echo "Введите путь к лог-файлу:"
        read log_path
        cleanup_by_log "$log_path"
        ;;
    2)
        cleanup_by_date
        ;;
    3)
        echo "Введите маску имени (формат: буквы_дата, например: az_120325):"
        read mask
        cleanup_by_mask "$mask"
        ;;
    *)
        echo "Ошибка: неверный параметр!"
        echo "Допустимые значения: 1, 2 или 3"
        exit 1
        ;;
esac

exit 0
