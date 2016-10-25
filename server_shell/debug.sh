#!/bin/bash

if [ $# -eq 1 ];then
	gdb --args skynet ./$1
elif [ $# -eq 2 ];then
	gdb --args skynet ./$1 ./$2
else
	sed -i "s/[[:blank:]]*logger[[:blank:]]*=.*/logger = nil/g" ../server_conf/config.common
	gdb --args skynet ./server_conf/config.common
fi
