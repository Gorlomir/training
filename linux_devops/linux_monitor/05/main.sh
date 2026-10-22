#!/bin/bash

. ./proverka.sh
. ./function.sh

check_parameters "$@"

target_dir="$1"

analyze_directory "$target_dir"

exit 0
