#!/bin/bash

NC='\033[0m'
RED='\033[31m'
GREEN='\033[32m'

. ./check.sh
# . ./create.sh

path=$1
count_fold=$2
list_of_fold=$3
count_files=$4
list_of_file=$5
size_files=$6
count_param=$#

# функции check и create_direcroty_with_files. В других скриптах
check $path $count_fold $list_of_fold $count_files $list_of_file $size_files
# create_direcroty_with_files