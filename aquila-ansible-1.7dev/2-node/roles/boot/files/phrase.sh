#!/usr/bin/env bash

input=$1

while read line || [ -n "$line" ]; do
    lines+=("${line}")
done < "$input"

sec_line=$(echo ${lines[0]})

sec=`echo "$sec_line" | cut -d':' -f 2`

echo $sec