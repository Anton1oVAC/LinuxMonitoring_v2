#!/bin/bash

name_sym=$1 # variable that will store the result
size_sym=${#name_sym} # returns the length of a string
caunter_generate=$2 # number of iterations to generate names

# variables for symbols
count_sym_1=1
count_sym_2=1
count_sym_3=1
count_sym_4=1
count_sym_7=1
count_sym_5=1
count_sym_6=1

if [[ $size_sym -eq 1 ]]; then
    name=$name_sym
    for (( i=0; i<$caunter_generate; i++ )) 
    	do
        	name+=$name_sym
    	done
elif [[ $size_sym -eq 2 ]]; then
    count_sym_1=2
    count_sym_2=2
    for (( i=1; i<$caunter_generate; i++ )) 
    	do
        	if [ $count_sym_1 -gt $count_sym_2 ]; then
            	let count_sym_2++
            	count_sym_1=1
        	else
            	let count_sym_1++
        	fi
    	done
    for (( i=0; i<$( expr $count_sym_1 + $count_sym_2 ); i++ )) 
    	do
        	if [ $i -lt $count_sym_1 ]; then
        		name+="${name_sym:0:1}"
        	else
            	name+="${name_sym:1:1}"
        	fi
    	done
elif [[ $size_sym -eq 3 ]]; then
    count_sym_1=2
    for (( i=1; i<$caunter_generate; i++ )) 
    	do
        	if [ $count_sym_2 -gt $count_sym_3 ]; then
            	let count_sym_3++
            	count_sym_2=1
				count_sym_1=1
			elif [ $count_sym_1 -gt $count_sym_2 ]; then
				let count_sym_2++
				count_sym_1=1
			else
				let count_sym_1++
			fi
		done
    for (( i=0; i<$( expr $count_sym_1 + $count_sym_2 + $count_sym_3 ); i++ )) 
		do
			if [ $i -lt $count_sym_1 ]; then
				name+="${name_sym:0:1}"
			elif [ $i -lt $( expr $count_sym_1 + $count_sym_2 ) ]; then
				name+="${name_sym:1:1}"
			else
				name+="${name_sym:2:1}"
			fi
		done
else
    if [ $size_sym -eq 4 ] 
    then
        count_sym_5=0
        count_sym_6=0
        count_sym_7=0
    elif [ $size_sym -eq 5 ] 
    then
        count_sym_6=0
        count_sym_7=0
    elif [ $size_sym -eq 6 ] 
    then
        count_sym_7=0
    fi
    for (( i=1; i<$caunter_generate; i++ )) 
		do
			if [ $size_sym -eq 7 ] && [ $count_sym_6 -gt $count_sym_7 ]; then
				let count_sym_7++
				count_sym_6=1
				count_sym_5=1
				count_sym_4=1
				count_sym_3=1
				count_sym_2=1
				count_sym_1=1
			elif [ $size_sym -gt 5 ] && [ $count_sym_5 -gt $count_sym_6 ]; then
				let count_sym_6++
				count_sym_5=1
				count_sym_4=1
				count_sym_3=1
				count_sym_2=1
				count_sym_1=1
			elif [ $size_sym -gt 4 ] && [ $count_sym_4 -gt $count_sym_5 ]; then
				let count_sym_5++
				count_sym_4=1
				count_sym_3=1
				count_sym_2=1
				count_sym_1=1
			elif [ $count_sym_3 -gt $count_sym_4 ]; then
				let count_sym_4++
				count_sym_3=1
				count_sym_2=1
				count_sym_1=1
			elif [ $count_sym_2 -gt $count_sym_3 ]; then
				let count_sym_3++
				count_sym_2=1
				count_sym_1=1
			elif [ $count_sym_1 -gt $count_sym_2 ]; then
				let count_sym_2++
				count_sym_1=1
			else
				let count_sym_1++
			fi
		done
    for (( i=0; i<$( expr $count_sym_1 + $count_sym_2 + $count_sym_3 + $count_sym_4 + $count_sym_5 + $count_sym_6 + $count_sym_7 ); i++ )) 
		do
			if [ $i -lt $count_sym_1 ]; then
				name+="${name_sym:0:1}"
			elif [ $i -lt $( expr $count_sym_1 + $count_sym_2 ) ]; then
				name+="${name_sym:1:1}"
			elif [ $i -lt $( expr $count_sym_1 + $count_sym_2 + $count_sym_3 ) ]; then
				name+="${name_sym:2:1}"
			elif [ $i -lt $( expr $count_sym_1 + $count_sym_2 + $count_sym_3 + $count_sym_4 ) ]; then
				name+="${name_sym:3:1}"
			elif [ $size_sym -gt 4 ] && [ $i -lt $( expr $count_sym_1 + $count_sym_2 + $count_sym_3 \
				+ $count_sym_4 + $count_sym_5 ) ]; then
				name+="${name_sym:4:1}"
			elif [ $size_sym -gt 5 ] && [ $i -lt $( expr $count_sym_1 + $count_sym_2 + $count_sym_3 \
				+ $count_sym_4 + $count_sym_5 + $count_sym_6 ) ]; then
				name+="${name_sym:5:1}"
			elif [ $size_sym -eq 7 ];then
				name+="${name_sym:6:1}"
			fi
		done
fi
echo $name