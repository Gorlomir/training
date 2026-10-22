#!/bin/bash
. ./gen.sh
. ./validate.sh
# Получаем параметры
ABSOLUTE_PATH=$1
NUM_FOLDERS=$2
FOLDER_LETTERS=$3
NUM_FILES=$4
FILE_NAME_EXT=$5
FILE_SIZE=$6

FILE_SIZE_KB=$(echo $FILE_SIZE | sed 's/kb//')

DATE=$(date +%d%m%y)
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
LOG_FILE="${script_dir}/creation_log_$(date +%Y%m%d_%H%M%S).log"
FILE_NAME=$(echo $FILE_NAME_EXT | cut -d'.' -f1)
FILE_EXT=$(echo $FILE_NAME_EXT | cut -d'.' -f2)
validate_params

main(){
cd "$ABSOLUTE_PATH" || exit 1


for ((folder_num=1; folder_num<=$NUM_FOLDERS; folder_num++)); do
    check_free_space
    
    folder_base_name=$(generate_folder_name "$FOLDER_LETTERS")
    folder_full_name="${folder_base_name}_${DATE}"
    folder_path="${ABSOLUTE_PATH}${folder_full_name}"

    mkdir -p "$folder_full_name"
    write_log "$LOG_FILE" "DIR|$folder_path|$(date '+%Y-%m-%d %H:%M:%S')"
    
    cd "$folder_full_name" || continue
    
    for ((file_num=1; file_num<=$NUM_FILES; file_num++)); do
        check_free_space
        
        file_base_name=$(generate_file_name "$FILE_NAME")
        file_full_name="${file_base_name}_${DATE}.${FILE_EXT}"
        file_path="${folder_path}/${file_full_name}"
        dd if=/dev/zero of="$file_full_name" bs=1024 count=$FILE_SIZE_KB 2>/dev/null
        write_log "$LOG_FILE" "FILE|$file_path|$(date '+%Y-%m-%d %H:%M:%S')|${FILE_SIZE_KB}KB"
    done
    
    cd "$ABSOLUTE_PATH" || exit 1
done

}

main
exit
