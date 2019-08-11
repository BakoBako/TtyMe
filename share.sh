#!/bin/bash

SCREEN_TMP_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
PID=$$
IP_ADDR="localhost"
PORT=8000

for i in "$@"
do
case $i in
    --public)
    IP_ADDR=`curl ip.mk`
    shift
    ;;
    -p=*|--port=*)
	PORT="${i#*=}"
	shift
	;;
    *)
          # unknown option
    ;;
esac
done

touch "/tmp/$SCREEN_TMP_FILE"
chmod 640 "/tmp/$SCREEN_TMP_FILE"

( while true; do 
	echo "$(cat /tmp/$SCREEN_TMP_FILE | /bin/bash ansi2html.sh --inline )" | 
	cat screen.headers - | nc -q 0 -l "8001" >> /dev/null; 
done ) &

( while true; do cat index.http | sed -e "s/IP_ADDR/$IP_ADDR/g" | nc -q 0 -l "$PORT" >> /dev/null; done ) &


echo "Screen share available on http://$IP_ADDR:$PORT"
echo "Kill server with command: kill 9 $PID"

script -f -q "/tmp/$SCREEN_TMP_FILE"
