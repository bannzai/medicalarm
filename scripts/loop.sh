#!/bin/sh

MAX_RETRY=10
INTERVAL=1

for i in $(seq 1 $MAX_RETRY); do
	echo "$i 回目"
	$1 && break
	sleep $INTERVAL
done


