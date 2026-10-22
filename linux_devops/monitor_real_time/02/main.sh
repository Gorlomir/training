#!/bin/bash

. ./gen.sh
. ./validate.sh

FOLDER_LETTERS=$1
FILE_NAME_EXT=$2
FILE_SIZE=$3

FILE_SIZE_MB=$(echo $FILE_SIZE | sed 's/Mb//')

FILE_NAME=$(echo $FILE_NAME_EXT | cut -d'.' -f1)
FILE_EXT=$(echo $FILE_NAME_EXT | cut -d'.' -f2)

validate_params

DATE=$(date +%d%m%y)

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
LOG_FILE="${script_dir}/creation_log_$(date +%Y%m%d_%H%M%S).log"

START_TIME=$(date +%s)
START_TIME_STR=$(date '+%Y-%m-%d %H:%M:%S')

main() {
    echo "Начало работы: $START_TIME_STR" | tee -a "$LOG_FILE"
    echo "Параметры: папки из букв '$FOLDER_LETTERS', файлы '$FILE_NAME.$FILE_EXT', размер ${FILE_SIZE_MB}MB" | tee -a "$LOG_FILE"

    local trees_created=0
    local max_trees=$((RANDOM % 50 + 1))
    local stop_flag=0


    for ((tree=1; tree<=$max_trees; tree++)); do
        check_free_space
        if [ $? -eq 1 ]; then
            stop_flag=1
            break
        fi

        local start_path=$(get_random_path)

        echo "=========================================" | tee -a "$LOG_FILE"
        echo "Создание структуры #$tree в директории: $start_path" | tee -a "$LOG_FILE"
        echo "=========================================" | tee -a "$LOG_FILE"

        # Создаем вложенные папки с файлами
        create_single_tree "$FOLDER_LETTERS" "$DATE" "$start_path"

        if [ $? -eq 0 ]; then
            ((trees_created++))
        else
            echo "Прервано создание структуры #$tree из-за нехватки места" | tee -a "$LOG_FILE"
            break
        fi

        sleep $((RANDOM % 3 + 1))
    done

}

main

END_TIME=$(date +%s)
END_TIME_STR=$(date '+%Y-%m-%d %H:%M:%S')
DURATION=$((END_TIME - START_TIME))

echo "========================================="
echo "Время начала работы: $START_TIME_STR"
echo "Время окончания работы: $END_TIME_STR"
echo "Общее время работы: $((DURATION / 60)) минут $((DURATION % 60)) секунд"
echo "========================================="

echo "=========================================" >> "$LOG_FILE"
echo "Время начала работы: $START_TIME_STR" >> "$LOG_FILE"
echo "Время окончания работы: $END_TIME_STR" >> "$LOG_FILE"
echo "Общее время работы: $((DURATION / 60)) минут $((DURATION % 60)) секунд" >> "$LOG_FILE"
echo "=========================================" >> "$LOG_FILE"

exit 0
