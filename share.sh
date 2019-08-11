#!/bin/bash

SCREEN_TMP_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
PID=$$

touch "/tmp/$SCREEN_TMP_FILE"
chmod 640 "/tmp/$SCREEN_TMP_FILE"

( while true; do 
	echo "$(cat /tmp/$SCREEN_TMP_FILE | /bin/bash ansi2html.sh --inline )" | 
	cat screen.headers - | nc -l -q 0 8001 >> /dev/null; 
done ) &

( while true; do cat index.http - | nc -l -q 0 8000 >> /dev/null; done ) &


echo "Screen share available on http://localhost:8000"
echo "Kill server with command: kill $PID"
script -f -q "/tmp/$SCREEN_TMP_FILE"
