#!/bin/bash/
info_table(){
        echo "HOSTNAME = $HOSTNAME"
        echo "TIMEZONE = $(timedatectl show --property=Timezone --value || date +%Z) UTC $(date +%:::z)"
        echo "USER = $USER"
        echo "OS = $(grep '^PRETTY_NAME=' /etc/os-release | cut -d'"' -f2)"
        echo "DATE = $(date +'%d %b %Y %T')"
        echo "UPTIME = $(uptime -p)"
        echo "UPTIME_SEC = $(cat /proc/uptime | awk '{print $1}') sec"
        echo "IP = $(hostname -I)"
        echo "MASK = $(ifconfig | grep netmask | head -1 | awk '{print $4}')"
        echo "GATEWAY = $(ip r | grep default | awk '{print $3}')"
        echo "RAM_TOTAL = $(grep MemTotal /proc/meminfo | awk '{printf "%.3f GB\n", $2/1024/1024}')"
        echo "RAM_USED = $(free -h | awk '/^Mem:/' | awk '{printf "%.3f GB\n", $3/1024}')"
        echo "RAM_FREE = $(grep MemFree /proc/meminfo | awk '{printf "%.3f GB\n", $2/1024/1024}')"
        echo "SPACE_ROOT = $(df -h / | awk 'NR==2 {printf "%.2f MB\n", $2*1024}')"
        echo "SPACE_ROOT_USED = $(df -h / | awk 'NR==2 {printf "%.2f MB\n", $3*1024}')"
        echo "SPACE_ROOT_FREE = $(df -h / | awk 'NR==2 {printf "%.2f MB\n", $4*1024}')" 
}

save_info(){
        read -p "Сохранить информацию в файл? (Y/N): " choice
        if [[ "$choice" == "Y" || "$choice" == "y" ]]; then
           filename="$(date +%d_%m_%Y_%H_%M_%S).status"
           info_table > "$filename"
        else exit 0
        fi 
}

