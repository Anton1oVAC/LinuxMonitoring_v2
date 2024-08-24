#!/bin/bash

error_target=0
NUMBER='[^0-9]+'
ALPHABET='[^a-zA-Z]+'
data="_$(date +"%d%m%y")"

# Parameter
path=$1
number_of_folders=$2
dir_name=$3
number_of_files=$4
file_name=$5
size_file=$6


# free_memory_kb=$(df / | awk 'NR==2{print $4}')
# free_memory_mb=$(echo "$free_memory_kb 1024" | awk '{printf "%.0f", $1 / $2}')

# # Echo memory: mb
# echo -e "${GREEN}free memory mb${NC}: $free_memort_mb"


# Checking for six parameters
if [ "$#" -ne 6 ]; then
	echo -e "${RED}ERROR${NC}: The number of arguments should be 6"
	exit 1
fi
avail_size=$(df -k / | grep /dev/mapper/ | awk '{print $4}')
	echo -e "${GREEN}Free memory up to${NC}: $avail_size"
if [ $avail_size -le 1048576 ]; then
	echo -e "${RED}ERROR${NC}: Not enough memory"
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


 # Second parameter
 if [[ $number_of_folders =~ $NUMBER ]]; then 
	if [[ $error_target == 1 ]]; then
		echo 
	fi
	echo -e "${RED}ERROR${NC}: The number of folders can only be described by a number."
	echo " Erroneous argument №2: $number_of_folders"
	error_target=1
fi


# Third parameter
no_repeat_cheker_dir=$(echo $dir_name | sed 's/\(.\)\1/\1/g')
if [ ${#dir_name} -gt 7 ]; then
	if [[ $error_target == 1 ]]; then
		echo 
	fi
	echo -e "${RED}ERROR${NC}: The number of characters to genetare a folder name should not exceed 7."
	echo " Erroneous argument №3: $dir_name"
	error_target=1
elif [[ $dir_name =~ $ALPHABET ]]; then
	if [[ $error_target == 1 ]]; then
		echo 
	fi	
	echo -e "${RED}ERROR${NC}: Only latin latters should be used to generate the folder name"
	echo " Erroneous argument №3: $dir_name"
	error_target=1
elif [[ ${#no_repeat_cheker_dir} -ne ${#dir_name} ]]; then
	if [[ $error_target == 1 ]]; then
		echo 
	fi
	echo -e "${RED}ERROR${NC}: The generating folder names should not be repeated"
	echo " Erroneus argument №3: $dir_name "
	error_target=1
fi


# Fourth parameter 
if [[ $number_of_files =~ $NUMBER ]]; then
	if [[ $error_target == 1 ]]; then
		echo
	fi
	echo -e "${RED}ERROR${NC}: The number of files can only be described by a number."
	echo " Erroneus argument №4: $number_of_files "
fi


# Fifth parameter
symbol_for_file_name=${file_name%.*}
symbol_for_expansion_file=${file_name#*.}
no_repeat_cheker_file_name=$(echo $file_name | sed 's/\(.\)\1/\1/g')
no_repeat_cheker_file_expansion=$(echo $file_name | sed 's/\(.\)\1/\1/g')
if [[ ! $file_name == *.* ]]; then
	if [[ $error_target == 1 ]]; then
		echo 
	fi
	echo -e "${RED}ERROR${NC}: There should be a dot between the file name and the extension"
	echo "Erroneus argument №5: $file_name "
	error_target=1
else	
	if [ ${#symbol_for_file_name} -gt 7 ]; then
		if [[ $error_target == 1 ]]; then
			echo 
		fi 
		echo -e "${RED}ERROR${NC}: The number of characters to generate a file name should not exceed 7."
		echo " Erroneus argument №5: $file_name"
		error_target=1
	elif [[ $symbol_for_file_name =~ $ALPHABET ]]; then
		if [[ $error_target == 1 ]]; then
			echo 
		fi 
		echo -e "${RED}ERROR${NC}: Only latin latters should be used to genetate the file name."
		echo " Erroneus argument №5: $file_name"
		error_target=1
	fi

	if [ ${#symbol_for_expansion_file} -gt 3 ]; then
		if [[ $error_target == 1 ]]; then
			echo 
		fi 
		echo -e "${RED}ERROR${NC}: The number of symbol to generate a file expansion should not exceed 3."
		echo " Erroneus argument №5: $file_name"
		error_target=1
	elif [[ $symbol_for_expansion_file =~ $ALPHABET ]]; then 
		if [[ $error_target == 1 ]]; then
			echo
		fi
		echo -e "${RED}ERROR${NC}: Only latin letters should be used to generate the file expansion. "
		echo " Erroneus argument №5: $file_name"
		error_target=1
	elif [[ ${#no_repeat_cheker_file_expansion} -ne ${#no_repeat_cheker_file_name} ]]; then
		if [[ $error_target == 1 ]]; then
			echo
		fi
		echo -e "${RED}ERROR${NC}: The generating file expansion should not be repeated."
		echo " Erroneus argument №5: $file_name"
		error_target=1
	fi
fi


# Sixth parameter
size_num_files=${size_file%kb*}
if [[ $size_num_files =~ $NUMBER && ! $size_file == *kb ]]; then 
	if [[ $error_target == 1 ]]; then
		echo
	fi
	echo -e "${RED}ERROR${NC}: The file size chould be described by the numnber and signature kb after."
	echo " Erroneus argument №6: $size_file"
	error_target=1
elif [[ $size_num_files -gt 100 ]]; then
	if [[ $error_target == 1 ]]; then 
	 	echo
	fi
	echo -e "${RED}ERROR${NC}: The amount of memory for the file should not exceed 100 kb"
	echo " Erroneus argument №6: $size_file"
	error_target=1
fi 


# Block for creating directories and files with unique names and dates
if [[ $error_target != 1 ]]; then
	touch "file-log.log"
	for (( i=1; i<=${number_of_folders}; i++))
	do 
		avail_size=$(df -k / | grep /dev/mapper/ | awk '{print $4}')
		if [ $avail_size -le 1048576 ]; then 
			echo -e "${RED}ERROR${NC}: Not enough memory"
			break
		fi
		name_dir="$(bash create.sh $dir_name $i)"
		mkdir "${path}${name_dir}${date}"
		echo -e "${path}${name_dir}${date}/\t\t\t\t\t$(date +"%d.%m.%y")" >> file-log.log
		for (( j=1; j <=${number_of_files}; j++))
		do
			avail_size=$(df -k / | grep /dev/mapper/ | awk '{print $4}')
			if [ $avail_size -le 1048576 ]; then
				echo -e "${RED}ERROR{NC}: Not egough memory"
				break
			fi
			name_file="$(bash create.sh $symbol_for_file_name $((j)))"
			fallocate -l ${size_file} "${path}${name_dir}${data}/${name_file}${data}.${symbol_for_expansion_file}"
			echo -e "${path}${name_dir}${data}/${name_file}${data}.${symbol_for_expansion_file}\t$(date +"%d".%m.%y)" >> file-log.log
			echo -e "${GREEN}Free memory after${NC}: $avail_size"
		done

	done
fi