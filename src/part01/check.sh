#!/bin/bash

free_memory_kb=$(df / | awk 'NR==2{print $4}')
free_memory_mb=$(echo "$free_memory_kb 1024" | awk '{printf "%.0f", $1 / $2}')

error_target=0
NUMBER='[^0-9]+'
ALPHABET='[^a-zA-Z]+'

# Parameter
path=$1
number_of_folders=$2
dir_name=$3
number_of_files=$4
file_name=$5
size_file=$6


# Echo memory: mb
echo "${GREEN}free memory mb${NC}: $free_memort_mb"


# Checking for six parameters
if [ "$#" -ne 6 ]; then
	echo -e "${RED}ERROR${NC}: The number of arguments should be 6"
	exit 1
fi
avail_size=$(df -k / | grep /dev/mapper/ | awk '{print $4}')
if [ $avail_size -le 1048576 ]; them
	echo -e "${RED}ERROR${NC}: Not enough memory"
	echo "Memory $avail_size"
	exit 1
fi


# First parameter
if [[ ${1:$((${#1}-1)):1} != / ]]; then
	echo -e "${RED}ERROR${NC}: The path must end with a '/'."
	error_target=1
elif [ ! -d $path ]; then
	echo "${RED}ERROR${NC}: Folder $path doesn't exsist."
	error_target=1
fi

