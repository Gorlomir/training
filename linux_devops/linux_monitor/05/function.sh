#!/bin/bash

analyze_directory() {
    local target_dir="$1"
    local start_time=$(date +%s.%N)
    local folder_count=$(tree "$target_dir" -d 2>/dev/null | tail -1 | grep -o '[0-9]*' | head -1)
    echo "Total number of folders (including all nested ones) = $folder_count"

    echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
    show_top_folders "$target_dir"

    local file_count=$(tree "$target_dir" 2>/dev/null | tail -1 | grep -o '[0-9]*' | tail -1)
    echo "Total number of files = $file_count"
    echo "Number of:"
    show_file_statistics "$target_dir"
    echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
    show_top_files "$target_dir"
    echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
    show_top_executables "$target_dir"
    local end_time=$(date +%s.%N)
    local execution_time=$(echo "$end_time - $start_time" | bc -l | awk '{printf "%.1f", $1}')
    echo "Script execution time (in seconds) = $execution_time"
}

show_top_folders() {
    local target_dir="$1"
    local counter=1
    du -h  "$target_dir" 2>/dev/null | sort -hr | tail -n +2 | head -5 | while IFS= read -r line; do
        local size=$(echo "$line" | awk '{print $1}')
        local path=$(echo "$line" | awk '{$1=""; print $0}' | sed 's/^ //')
        echo "$counter - $path, $size"
        ((counter++))
    done
}

show_file_statistics() {
    local target_dir="$1"
    local conf_count=$(find "$target_dir" -type f -name "*.conf" 2>/dev/null | wc -l)
    echo "Configuration files (with the .conf extension) = $conf_count"
    local text_count=$(find "$target_dir" -type f \( -name "*.txt" -o -name "*.md" -o -name "*.pdf" -o -name "*.tex" -o -name "*.rst" \) 2>/dev/null | wc -l)
    echo "Text files = $text_count"
    local exec_count=$(find "$target_dir" -type f -executable 2>/dev/null | wc -l)
    echo "Executable files = $exec_count"
    local log_count=$(find "$target_dir" -type f -name "*.log" 2>/dev/null | wc -l)
    echo "Log files (with the extension .log) = $log_count"
    local archive_count=$(find "$target_dir" -type f \( -name "*.zip" -o -name "*.tar" -o -name "*.gz" -o -name "*.bz2" -o -name "*.xz" -o -name "*.7z" -o -name "*.rar" -o -name "*.tgz" -o -name "*.tbz2" \) 2>/dev/null | wc -l)
    echo "Archive files = $archive_count"
    local symlink_count=$(find "$target_dir" -type l 2>/dev/null | wc -l)
    echo "Symbolic links = $symlink_count"
}

show_top_files() {
    local target_dir="$1"
    local counter=1
    find "$target_dir" -type f -exec du -h {} + 2>/dev/null | sort -hr | head -10 | while IFS= read -r line; do
        local size=$(echo "$line" | awk '{print $1}')
        local path=$(echo "$line" | awk '{$1=""; print $0}' | sed 's/^ //')
        local file_type=$(get_file_type "$path")
        echo "$counter - $path, $size, $file_type"
        ((counter++))
    done
}

get_file_type() {
    local path="$1"
    local filename=$(basename "$path")
    local extension="${filename##*.}"
    local ext_lower=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
    if [[ -z "$extension" ]] || [[ "$ext_lower" == "$filename" ]]; then
        if [ -x "$path" ]; then
            echo "executable"
        else
            local file_info=$(file -b "$path" 2>/dev/null | head -1)
            if [ -n "$file_info" ]; then
                echo "$file_info" | awk '{print $1}' | tr -d ','
            else
                echo "unknown"
            fi
        fi
        return
    fi
    case "$ext_lower" in
        conf) echo "conf" ;;
        log) echo "log" ;;
        txt|md|pdf|tex|rst|org|asciidoc) echo "text" ;;
        sh|bash|zsh|pl|py|rb|php|js|perl) echo "script" ;;
        zip|tar|gz|bz2|xz|7z|rar|tgz|tbz2|txz|deb|rpm) echo "archive" ;;
        jpg|jpeg|png|gif|bmp|svg|ico|tiff|webp) echo "image" ;;
        mp3|wav|flac|ogg|m4a|aac|opus) echo "audio" ;;
        mp4|avi|mkv|mov|wmv|flv|webm|mpeg|mpg) echo "video" ;;
        c|cpp|h|hpp|java|go|rs|swift|js|ts|php|py|rb) echo "source" ;;
        html|htm|xml|json|yml|yaml|css) echo "markup" ;;
        *)
            if [ -x "$path" ]; then
                echo "executable"
            else
                echo "$ext_lower"
            fi
            ;;
    esac
}

show_top_executables() {
    local target_dir="$1"
    local counter=1
    find "$target_dir" -type f -executable -exec du -h {} + 2>/dev/null | sort -hr | head -10 | while IFS= read -r line; do
        local size=$(echo "$line" | awk '{print $1}')
        local path=$(echo "$line" | awk '{$1=""; print $0}' | sed 's/^ //')
        local file_hash=$(get_md5_hash "$path")
        echo "$counter - $path, $size, $file_hash"
        ((counter++))
    done
}

get_md5_hash() {
    local path="$1"
    
    if [ ! -f "$path" ] || [ ! -r "$path" ]; then
        echo "N/A"
        return
    fi
    
    md5sum "$path" 2>/dev/null | cut -d' ' -f1 || echo "N/A"
}
