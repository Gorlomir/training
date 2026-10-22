#!/bin/bash/

color_choice(){
	local text_num=$1
        local bg_num=$2
	declare -A color_map
	color_map=(
	  ["1"]="37" #white
	  ["2"]="31" #red
	  ["3"]="32" #green
	  ["4"]="34" #blue
	  ["5"]="35" #purple
	  ["6"]="30" #black
	)
	declare -A color_map_bg
	color_map_bg=(
	  ["1"]="47" #white
          ["2"]="41" #red
          ["3"]="42" #green
          ["4"]="44" #blue
          ["5"]="45" #purple
          ["6"]="40" #black
	)
	echo "${color_map[$text_num]};${color_map_bg[$bg_num]}"

}
color_choice_zn(){
	local text_zn_num=$1
	local bg_zn_num=$2

	declare -A color_map_zn
        color_map_zn=(
          ["1"]="37"
          ["2"]="31"
          ["3"]="32"
          ["4"]="34"
          ["5"]="35"
          ["6"]="30"
        )
        declare -A color_map_bg_zn
        color_map_bg_zn=(
          ["1"]="47"
          ["2"]="41"
          ["3"]="42"
          ["4"]="44"
          ["5"]="45"
          ["6"]="40"
        )

	echo "${color_map_zn[$text_zn_num]};${color_map_bg_zn[$bg_zn_num]}"
}

info_table(){
	local color_code=$(color_choice "$1" "$2")
        local color_code_zn=$(color_choice_zn "$3" "$4")
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

