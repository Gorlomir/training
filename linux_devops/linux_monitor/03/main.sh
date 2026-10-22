#!bin/bash
. ./function.sh
. ./proverki.sh
main(){
	proverka "$@"
	if [[ $? -ne 0 ]]; then
        	return 1
	fi
	info_table "$1" "$2" "$3" "$4"
}

main "$@"
exit 0
