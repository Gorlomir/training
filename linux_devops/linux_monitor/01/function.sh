#!/bin/bash

check_count() {
        if [[ $# -ne 1 ]]; then
           echo "ERROR"
           return 1
        fi
        return 0
}
is_number() {
        if [[ "$1" =~ ^[0-9]+$ ]]; then
           echo "ERROR"
           return 1
        fi
        echo "$1"
        return 0
}
