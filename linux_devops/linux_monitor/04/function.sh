#!/bin/bash/
. ./color_func.sh

DEFAULT_COLUMN1_BG=6
DEFAULT_COLUMN1_FONT=3
DEFAULT_COLUMN2_BG=6
DEFAULT_COLUMN2_FONT=3

check_config(){
 local all_params_present=1

    declare -A params=(
        ["column1_background"]=""
        ["column1_font_color"]=""
        ["column2_background"]=""
        ["column2_font_color"]=""
    )
    if [[ -f "./color_config.conf" ]]; then

        for param_name in "${!params[@]}"; do
            local value=$(grep "^${param_name}=" ./color_config.conf | cut -d'=' -f2)
            if [[ -n "$value" && "$value" =~ ^[1-6]$ ]]; then
                params["$param_name"]="$value"
            fi
        done

        all_params_present=0
        for param_name in "${!params[@]}"; do
            if [[ -z "${params[$param_name]}" ]]; then
                all_params_present=1
                break
            fi
        done
    fi

    if [[ $all_params_present -eq 0 ]]; then
        color1_bg="${params[column1_background]}"
        color1_font="${params[column1_font_color]}"
        color2_bg="${params[column2_background]}"
        color2_font="${params[column2_font_color]}"
        use_default_scheme=0
    else
        color1_bg="$DEFAULT_COLUMN1_BG"
        color1_font="$DEFAULT_COLUMN1_FONT"
        color2_bg="$DEFAULT_COLUMN2_BG"
        color2_font="$DEFAULT_COLUMN2_FONT"
        use_default_scheme=1
    fi
}
info_table(){
    use_default_scheme=0
    check_config
    if [[ "$color1_font" -eq "$color1_bg" ]]; then
        echo "Цвет текста и фона в первой колонке совпадают, меняй конфиг"
        exit 1
    fi

    if [[ "$color2_font" -eq "$color2_bg" ]]; then
        echo "Цвет текста и фона во второй колонке совпадают, меняй конфиг"
        exit 1
    fi
    for i in "$color1_font" "$color1_bg" "$color2_font" "$color2_bg"; do
        if ! [[ "$i" =~ ^[0-9]+$ ]]; then
            echo "Параметр '$i' в конфиге не является числом, меняй конфиг."
            exit 1
        fi
    done
    local color_code=$(color_choice "$color1_font" "$color1_bg")
    local color_code_zn=$(color_choice_zn "$color2_font" "$color2_bg")
    echo -e "\e[${color_code}mHOSTNAME\e[0m = \e[${color_code_zn}m$HOSTNAME\e[0m"
    echo -e "\e[${color_code}mTIMEZONE\e[0m = \e[${color_code_zn}m$(timedatectl show --property=Timezone --value || date +%Z) UTC $(date +%:::z)\e[0m"
    echo -e "\e[${color_code}mUSER\e[0m = \e[${color_code_zn}m$USER\e[0m"
    echo -e "\e[${color_code}mOS\e[0m = \e[${color_code_zn}m$(grep '^PRETTY_NAME=' /etc/os-release | cut -d'"' -f2)\e[0m"
    echo -e "\e[${color_code}mDATE\e[0m = \e[${color_code_zn}m$(date +'%d %b %Y %T')\e[0m"
    echo -e "\e[${color_code}mUPTIME\e[0m = \e[${color_code_zn}m$(uptime -p)\e[0m"
    echo -e "\e[${color_code}mUPTIME_SEC\e[0m = \e[${color_code_zn}m$(cat /proc/uptime | awk '{print $1}') sec\e[0m"
    echo -e "\e[${color_code}mIP\e[0m = \e[${color_code_zn}m$(hostname -I)\e[0m"
    echo -e "\e[${color_code}mMASK\e[0m = \e[${color_code_zn}m$(ifconfig | grep netmask | head -1 | awk '{print $4}')\e[0m"
    echo -e "\e[${color_code}mGATEWAY\e[0m = \e[${color_code_zn}m$(ip r | grep default | awk '{print $3}')\e[0m"
    echo -e "\e[${color_code}mRAM_TOTAL\e[0m = \e[${color_code_zn}m$(grep MemTotal /proc/meminfo | awk '{printf "%.3f GB\n", $2/1024/1024}')\e[0m"
    echo -e "\e[${color_code}mRAM_USED\e[0m = \e[${color_code_zn}m$(free -h | awk '/^Mem:/' | awk '{printf "%.3f GB\n", $3/1024}')\e[0m"
    echo -e "\e[${color_code}mRAM_FREE\e[0m = \e[${color_code_zn}m$(grep MemFree /proc/meminfo | awk '{printf "%.3f GB\n", $2/1024/1024}')\e[0m"
    echo -e "\e[${color_code}mSPACE_ROOT\e[0m = \e[${color_code_zn}m$(df -h / | awk 'NR==2 {printf "%.2f MB\n", $2*1024}')\e[0m"
    echo -e "\e[${color_code}mSPACE_ROOT_USED\e[0m = \e[${color_code_zn}m$(df -h / | awk 'NR==2 {printf "%.2f MB\n", $3*1024}')\e[0m"
    echo -e "\e[${color_code}mSPACE_ROOT_FREE\e[0m = \e[${color_code_zn}m$(df -h / | awk 'NR==2 {printf "%.2f MB\n", $4*1024}')\e[0m"
}
