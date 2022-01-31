#!/usr/bin/env bash

input=$1

while read line || [ -n "$line" ]; do
    lines+=("${line}")
done < "$input"

sec_line=$(echo ${lines[0]})
sec=`echo "$sec_line" | cut -d'\`' -f 2`

acc_line=$(
    echo ${lines[3]// })
acc=`echo "$acc_line" | cut -d':' -f 2`

json='{"jsonrpc": "2.0","id":1,"method":"author_insertKey","params":["'"$input"'","'"$sec"'","'"$acc"'"]}'

echo $json