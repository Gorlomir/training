#!/bin/bash

generate_ip(){
 echo "$(( $RANDOM % 255 + 1)).$(( $RANDOM % 255 + 1)).$(( $RANDOM % 255 + 1)).$(( $RANDOM % 255 + 1))"
}

random_response(){
 echo "${response_base[$RANDOM % ${#response_base[@]}]}"
}
random_method(){
 echo "${methods_base[$RANDOM % ${#methods_base[@]}]}"
}

random_url() {
    echo "${urls[RANDOM % ${#urls[@]}]}"
}

random_user_agent() {
    echo "${user_agents[RANDOM % ${#user_agents[@]}]}"
}

generate_datetime() {
    local day=$1
    local hour=$((RANDOM % 24))
    local minute=$((RANDOM % 60))
    local second=$((RANDOM % 60))
    printf "%02d/Mar/2025:%02d:%02d:%02d +0000" "$day" "$hour" "$minute" "$second"
}
