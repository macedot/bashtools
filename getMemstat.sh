#!/bin/bash

if [ -z "$1"			 ]; then
	echo "Usage (example): perl ./perl_test.pl | ./runtest.sh perl outputfile"
	exit
fi

OF=$2

if [ -z "$OF" ]; then
	OF="${1}.testdata"
fi

PID=`/bin/pidof $1`
if [ -z "$PID" ]; then
    echo "Unable to find Process ID"
    exit
fi

while true; do
	read line || break
	echo "$line"

	echo $line >>$OF
	#pidof $1 | xargs memstat -w -p >>$OF
	memstat -w -p $PID >>$OF
	echo >>$OF
done


