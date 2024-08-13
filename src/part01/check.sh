#!/bin/bash

path_check='^/[a-zA-Z0-9/_-]+$'
check_abs_path='^/$'

check_count_dir='^[1-9]+$' 
check_letter_dir='^[a-zA-Z]{1,7}$'
check_count_file='^[0-9]+$'
check_letter_file='^[a-zA-Z]{1,7}\.{1,1}[a-zA-Z]{1,3}$'

size_files='^[0-9]+(kb|KB|kB|Kb)$'
size_number=$(echo "$6" | sed 's/[kK][bB]//')

check() {
	if [ $count_param -ne 6 ]; then
		echo -e "${RED}ERROR${NC}: invalid number of arguments!"
		exit 1

	elif ! [[ $1 =~ $path_check || $1 =~ $check_abs_path ]]; then
		echo -e "${RED}ERROR${NC}: the first parameer is equal to the absolute path"
		exit 2

	# Является ли параметр директорией
	elif ! [[ -d $1 ]]; then
		echo -e "${RED}ERROR${NC}: invalid directory"
		exit 3

	# Имеет ли объект право на запись
	elif ! [[ -w $1 ]]; then
		echo -e "${RED}ERROR${NC}: the object does not have write permissions"
		exit 4
	
	elif ! [[ $2 =~ $check_count_dir ]]; then
		echo -e "${RED}ERROR${NC}: invalid second parameter. ${RED}Number${NC}"
		exit 5

	elif ! [[ $3 =~ $check_letter_dir ]]; then
		echo -e "${RED}ERROR${NC}: invalid third parameter. ${RED}Letter${NC}"
		exit 6

	elif ! [[ $4 =~ $check_count_file ]]; then
		echo -e "${RED}ERROR${NC}: invalid fourth parameter. ${RED}Number${NC}"
		exit 7

	elif ! [[ $5 =~ $check_letter_file ]]; then
		echo -e "${RED}ERROR${NC}: ivalid fifth parameter." 
		echo -e "${GREEN}Two numbers${NC}:" 
		echo -e "${GREEN}First digit of file name. Letters (Quantity 1-7)${NC}"
		echo -e "${GREEN}Second digit of file extension. Letters (Quantity 1-3)${NC}"
		exit 8

	# костыль
	elif ! [[ $6 =~ $size_files ]]; then
		exit 9
		
	# Точнее, вот костыль
	elif ! [[ $size_number =~ ^[0-9]+$ ]]; then
		echo -e "${RED}ERROR${NC}: invalid sixth parameter. ${RED}Number+kb|KB|kB|Kb${NC}"
    	exit 10

	elif [ $size_number -gt 100 ]; then
		echo -e "${RED}ERROR${NC}: large file"
		exit 11
	fi
}
