#!/bin/bash

log_files="../04/nginx/*.log"
case $1 in
	1)
	  awk '{print $9 " - " $0}' $log_files | sort -n | awk '{$1=""; print substr($0,2)}'
	  ;;
	2)
	  awk '{print $1}' $log_files | sort | uniq -c | sort -nr
	  ;;
	3)
	  awk '$9 >= 400 && $9 <= 599' $log_files
	  ;;
	4)
	  awk '$9 >= 400 && $9 <=599 {print $1}' $log_files | sort -u
	  ;;
	*)
	  echo "error"
	  exit 1
	  ;;
esac

exit 0

