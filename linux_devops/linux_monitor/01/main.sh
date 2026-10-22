#!/bin/bash
source ./function.sh
main() {
check_count "$@" || return 1
is_number "$1"
return 0
}

main "$@"

exit $?
