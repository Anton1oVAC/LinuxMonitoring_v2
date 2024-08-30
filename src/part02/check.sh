#!/bin/bash

d=$(date)
echo "$d"

NC='\033[0m'
RED='\033[031m'
GREEN='\033[032m'

error_target=0
ALPHABET='[^a-zA-Z]+'
NUMBER='[^0-9]+'

start_time_nanosec=$(date +%s%N)
start_time=$(date +%H:%M:%S)

end_time_nanosec=$(date +%s%N)
end_time=$(date +%H:%M:%S)

# Parameter 
create_of_folders=$1
create_of_files=$2
size_file=$3


# checking incoming arguments and checking memory 
if [ $# -ne 3 ]; then 
	echo -e "${RED}ERROR${NC}: The number of arguments should be 3"
	exit 1
fi
avail_size=$(df -k / | grep /dev/mapper/ | awk '{print $4}')
	echo -e "${GREEN}Free memory${NC}: $avail_size"
if [ $avail_size -le 1048576 ]; then
	echo -e "${RED}ERROR${NC}: Not enough memory"
	exit 1
fi


# First parameter
no_repeat_cheker_dir=$(echo $create_of_folders | sed 's/\(.\)\1/\1/g')
if [ ${#create_of_folders} -gt 7 ]; then
	if [[ $error_target == 1 ]]; then
		echo 
	fi
	echo -e "${RED}ERROR${NC}: The number of characters to genetare a folder name should not exceed 7."
	echo " Erroneous argument №1: $create_of_folders"
	error_target=1
elif [[ $create_of_folders =~ $ALPHABET ]]; then
	if [[ $error_target == 1 ]]; then
		echo 
	fi	
	echo -e "${RED}ERROR${NC}: Only latin latters should be used to generate the folder name"
	echo " Erroneous argument №1: $create_of_folders"
	error_target=1
elif [[ ${#no_repeat_cheker_dir} -ne ${#create_of_folders} ]]; then
	if [[ $error_target == 1 ]]; then
		echo 
	fi
	echo -e "${RED}ERROR${NC}: The generating folder names should not be repeated"
	echo " Erroneus argument №1: $create_of_folders "
	error_target=1
fi


# Second marameter 
symbol_for_file_name=${create_of_files%.*}
symbol_for_expansion_file=${create_of_files#*.}
no_repeat_cheaker_file_name=$(echo $symbol_for_file_name | sed 's/\(.\)\1/\1/g')
no_repeat_cheaker_file_expansion=$(echo $symbol_for_expansion_file | sed 's/\(.\)\1/\1/g')
if [[ ! $create_of_files == *.* ]]; then
	if [[ $error_target == 1 ]]; then
		echo
	fi
	echo -e "${RED}ERROR${NC}: There should be a dot between the file name and the extension"
	echo "Erroneous argument №2: $create_of_files"
	error_target=1
else
	if [[ $symbol_for_file_name -gt 7 ]]; then
		if [[ $error_target == 1 ]]; then
			echo 
		fi
		echo -e "${RED}ERROR${NC}: The number of characters to genetare a folder name should not exceed 7."
		echo "Erroneous argument №2: $create_of_files"
		error_target=1
	elif [[ $symbol_for_file_name =~ $ALPHABET ]]; then
		if [[ $error_target == 1 ]]; then
			echo 
		fi
		echo -e "${RED}ERROR${NC}: Only latin latters should be used to generate the folder name."
		echo "Erroneous argument №2: $create_of_files"
		error_target=1
	fi

	if [[ $symbol_for_expansion_file -gt 3 ]]; then
		if [[ $error_target == 1 ]]; then
			echo
		fi
		echo -e "${RED}ERROR${NC}: The number of characters to genetare a folder name should not exceed 3."
		echo "Erroneous argument №2: $create_of_files"
		error_target=1
	elif [[ $symbol_for_expansion_file =~ $ALPHABET ]]; then
		if [[ $error_target == 1 ]]; then
			echo 
		fi 
		echo -e "${RED}ERROR${NC}: Only latin latters should be used to generate the folder name."
		echo "Erroneous argument №2: $create_of_files"
		error_target=1
	elif [[ ${#no_repeat_cheaker_file_expansion} -ne ${#symbol_for_expansion_file} ]]; then
		if [[ $error_target == 1 ]]; then
			echo 
		fi 
		echo -e "${RED}ERROR${NC}: The generating folder names should not be repeate."
		echo "Erroneous argument №2: $create_of_files"
		error_target=1
	fi
fi


# Threeth parameter
size_num_files=${size_file%Mb*}
if [[ $size_num_files =~ $NUMBER && ! $size_file == *Mb ]]; then
	if [[ $error_target == 1 ]]; then
		echo
	fi
	echo -e "${RED}ERROR${NC}: The file size chould be described by the numnber and signature Mb after."
	echo " Erroneus argument №3: $size_file"
	error_target=1
elif [ $size_num_files -gt 100 ]; then
	if [[ $error_target == 1 ]]; then
		echo 
	fi
	echo -e "${RED}ERROR${NC}: The amount of memory for the file should not exceed 100 Mb"
	echo " Erroneus argument №3: $size_file"
	error_target=1
fi


#  creating folders and files
if [[ $error_target != 1 ]]; then
    touch "file.log"
    data="_$(date +"%d%m%y")"
    rand_folders=$(($RANDOM%100))
    for (( i=1; i<=${rand_folders}; i++ )) do
        avail_size=$(df -k / | grep /dev/mapper/ | awk '{print $4}')
        	if [ $avail_size -le 1048576 ]; then
            	echo -e "${RED}Stop${NC}: ${GREEN}Not enough memory for folders${NC}"
            	break
        	fi
        path="$(find /home -type d 2>/dev/null | grep -E '[^(bin|sbin)]' | head -n$(($RANDOM%650)) | tail -n1)/"
        name_dir="$(bash create.sh $create_of_folders $i)"
        mkdir "${path}${name_dir}${data}"
        echo -e "${path}${name_dir}${data}/\t\t\t\t\t$(date +"%d.%m.%y")" >> file.log
        rand_files=$(($RANDOM%100))
        for (( j=1; j<=${rand_files}; j++ )) do
            avail_size=$(df -k / | grep /dev/mapper/ | awk '{print $4}')
            	if [ $avail_size -le 1048576 ]; then
                	echo -e "${RED}Stop${NC}: ${GREEN}Not enough memory for folders${NC}"
                	break
            	fi
            name_file="$(bash create.sh $symbol_for_file_name $((j)))"
            fallocate -l ${size_file} "${path}${name_dir}${data}/${name_file}${data}.${symbol_for_expansion_file}"
            echo -e "${path}${name_dir}${data}/${name_file}${data}.${symbol_for_expansion_file}\t$(/bin/date +"%d.%m.%y") ${size_num_files}" >> file.log
        done
    done
	echo -e "${GREEN}Free memory${NC}: $avail_size"
    echo -e "${GREEN}Start time${NC}: $start_time"
    echo -e "${GREEN}End time${NC}: $end_time"
    echo -e "${GREEN}Total workong time${NC}: $((($end_time_nanosec - $start_time_nanosec)/1000000000)) seconds"
    echo "Start time: $start_time" >> file.log
    echo "End time: $end_time" >> file.log
    echo "Total workong time$: $((($end_time_nanosec - $start_time_nanosec)/1000000000)) seconds" >> file.log
fi