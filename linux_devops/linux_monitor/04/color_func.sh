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
        local fg=${color_map[$text_num]}
        local bg=${color_map_bg[$bg_num]}
        echo "${fg};${bg}"
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
        local fg=${color_map_zn[$text_zn_num]}
        local bg=${color_map_bg_zn[$bg_zn_num]}
        echo "${fg};${bg}"
}
get_color_name() {
    case $1 in
        "1") echo "white" ;;
        "2") echo "red" ;;
        "3") echo "green" ;;
        "4") echo "blue" ;;
        "5") echo "purple" ;;
        "6") echo "black" ;;
        *) echo "" ;;

    esac
}

color_conf_info(){
    local color1_bg_name=$(get_color_name "$color1_bg")
    local color1_font_name=$(get_color_name "$color1_font")
    local color2_bg_name=$(get_color_name "$color2_bg")
    local color2_font_name=$(get_color_name "$color2_font")

    local default_col1_bg_name=$(get_color_name "$DEFAULT_COLUMN1_BG")
    local default_col1_font_name=$(get_color_name "$DEFAULT_COLUMN1_FONT")
    local default_col2_bg_name=$(get_color_name "$DEFAULT_COLUMN2_BG")
    local default_col2_font_name=$(get_color_name "$DEFAULT_COLUMN2_FONT")
    echo -e "\nColumn 1 background = $(if [[ $color1_bg_default -eq 0 ]]; then echo "${color1_bg} (${color1_bg_name})"; else echo "default (${color1_bg_name})"; fi)"
    echo "Column 1 font color = $(if [[ $color1_font_default -eq 0 ]]; then echo "${color1_font} (${color1_font_name})"; else echo "default (${color1_font_name})"; fi)"
    echo "Column 2 background = $(if [[ $color2_bg_default -eq 0 ]]; then echo "${color2_bg} (${color2_bg_name})"; else echo "default (${color2_bg_name})"; fi)"
    echo "Column 2 font color = $(if [[ $color2_font_default -eq 0 ]]; then echo "${color2_font} (${color2_font_name})"; else echo "default (${color2_font_name})"; fi)"
}


