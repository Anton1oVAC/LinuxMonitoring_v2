#!/bin/bash

NC='\033[0m'
RED='\033[031m'
GREEN='\033[032m'

FILE_LOG=$2

if [ ! -f "$FILE_LOG" ]; then 
	echo -e "${RED}ERROR${NC}: The file "$FILE_LOG" not found"
fi

if [ $# -ne 2 ]; then
	echo -e "${RED}ERROR${NC}: The number arguments corresponds to one"
	exit 
fi

if [ $1 -eq 1 ]; then 
	awk '{ print }' "$FILE_LOG" | sort -k 9
elif [ $1  -eq 2 ]; then
	awk '{ print }' "$FILE_LOG" | uniq
elif [ $1 -eq 3 ]; then
	awk '/400|401|403|404|500|501|502|503/{ s = ""; for ( i = 7; i <= 9; i++ ) s = s $i " "; print s}' "$FILE_LOG"
elif [ $1 -eq 4 ]; then
	awk '/400|401|403|404|500|501|502|503/{ print $1 " - " $9 }' "$FILE_LOG" | sort | uniq 
else
	echo -e "${RED}ERROR${NC}: unsupported argument type"
fi
