#!/bin/bash

generate_folder_name() {
    local letters=$1
    local min_length=4
    local name=""

    name=$letters

    local extra_chars=$((RANDOM % 21))

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

    local extra_chars=$((RANDOM % 21))

    local current_length=${#name}
    local target_length=$((min_length + extra_chars))

    while [ $current_length -lt $target_length ]; do
        local random_index=$((RANDOM % ${#name_part}))
        name="${name}${name_part:$random_index:1}"
        current_length=$((current_length + 1))
    done

    echo "$name"
}

check_free_space() {
    local free_space_mb=$(df / | awk 'NR==2 {print $4}' | awk '{print int($1/1024)}')

    if [ $free_space_mb -lt 1024 ]; then
        local free_space_human=$(df -h / | awk 'NR==2 {print $4}')
        echo "Внимание: Осталось менее 1 ГБ свободного места ($free_space_human). Остановка создания." | tee -a "$LOG_FILE"
        return 1
    fi
    return 0
}

write_log() {
    local log_file=$1
    local log_entry=$2
    echo "$log_entry" >> "$log_file"
}

get_random_path() {
    local exclude_patterns=("bin" "sbin")
    local max_attempts=50
    local attempt=0

    local base_dirs=(
        "/home"
        "/tmp"
        "/opt"
        "/mnt"
        "/media"
        "$HOME"
        "$(pwd)"
    )

    if [ -d "/home" ]; then
        for user_home in /home/*; do
            if [ -d "$user_home" ]; then
                base_dirs+=("$user_home")
            fi
        done
    fi

    base_dirs=($(printf "%s\n" "${base_dirs[@]}" | sort -u))

    while [ $attempt -lt $max_attempts ]; do
        local random_base="${base_dirs[$RANDOM % ${#base_dirs[@]}]}"

        if [ ! -d "$random_base" ] || [ ! -w "$random_base" ]; then
            ((attempt++))
            continue
        fi

        if [[ "$random_base" == "/home"* ]] || [[ "$random_base" == "$HOME"* ]]; then
            echo "$random_base"
            return 0
        fi

        local depth=$((RANDOM % 4 + 1))
        local current_path="$random_base"

        for ((i=1; i<=depth; i++)); do
            local subdirs=()
            while IFS= read -r dir; do
                local exclude=false
                for pattern in "${exclude_patterns[@]}"; do
                    if [[ "$dir" == *"/$pattern"* ]] || [[ "$dir" == *"/$pattern/"* ]]; then
                        exclude=true
                        break
                    fi
                done

                if [ "$exclude" = false ] && [ -w "$dir" ] && [ -d "$dir" ]; then
                    subdirs+=("$dir")
                fi
            done < <(find "$current_path" -maxdepth 1 -type d ! -path "$current_path" 2>/dev/null)
            # Если есть поддиректории, случайно выбираем одну
            if [ ${#subdirs[@]} -gt 0 ]; then
                current_path="${subdirs[$RANDOM % ${#subdirs[@]}]}"
            else
                break
            fi
        done

        if [ -d "$current_path" ] && [ -w "$current_path" ]; then
            local exclude_final=false
            for pattern in "${exclude_patterns[@]}"; do
                if [[ "$current_path" == "/$pattern"* ]] || [[ "$current_path" == *"/$pattern/"* ]]; then
                    exclude_final=true
                    break
                fi
            done

            if [ "$exclude_final" = false ]; then
                echo "$current_path"
                return 0
            fi
        fi

        ((attempt++))
    done

    if [ -w "$HOME" ]; then
        echo "$HOME"
    else
        echo "/tmp"
    fi
    return 1
}
create_single_tree() {
    local letters=$1
    local date=$2
    local start_path=$3

    local depth=0
    local max_depth=$((RANDOM % 100 + 1))
    local current_path="$start_path"

    echo "Создание структуры в: $current_path, глубина: $max_depth" | tee -a "$LOG_FILE"

    while [ $depth -lt $max_depth ]; do
        # Проверяем свободное место
        check_free_space
        if [ $? -eq 1 ]; then
            return 1
        fi

        # Генерируем имя папки
        local folder_name=$(generate_folder_name "$letters")
        local full_folder_name="${folder_name}_${date}"
        local new_path="${current_path}/${full_folder_name}"

        # Создаем папку
        mkdir -p "$new_path" 2>/dev/null
        if [ $? -ne 0 ]; then
            echo "Не удалось создать папку: $new_path" | tee -a "$LOG_FILE"
            break
        fi

        folder_path=$(realpath "$new_path")
        write_log "$LOG_FILE" "DIR|$folder_path|$(date '+%Y-%m-%d %H:%M:%S')|"

        # Создаем случайное количество файлов в этой папке
        local num_files=$((RANDOM % 100 + 1))
        local files_created=0

        for ((file_num=1; file_num<=$num_files; file_num++)); do
            check_free_space
            if [ $? -eq 1 ]; then
                return 1
            fi

            local file_base_name=$(generate_file_name "$FILE_NAME")
            local file_full_name="${file_base_name}_${date}.${FILE_EXT}"

            dd if=/dev/zero of="${new_path}/${file_full_name}" bs=1M count=$FILE_SIZE_MB 2>/dev/null
            file_path=$(realpath "${new_path}/${file_full_name}")
            write_log "$LOG_FILE" "FILE|$file_path|$(date '+%Y-%m-%d %H:%M:%S')|${FILE_SIZE_MB}MB"
            ((files_created++))
        done

        echo "Папка $full_folder_name: создано $files_created файлов" >> "$LOG_FILE"

        # Переходим на следующий уровень
        current_path="$new_path"
        ((depth++))
    done

    echo "Завершено создание структуры глубиной $depth уровней" | tee -a "$LOG_FILE"
    return 0
}
