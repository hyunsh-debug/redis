#!/bin/sh
  
REDIS_HOME=/sw/home/redis
REDIS_NAME=redis-server
REDIS_PORT=6379
REDIS_TYPE=master
#REDIS_TYPE=slave
REDIS_CONF=redis_${REDIS_TYPE}_6379.conf
  
PID=`ps -eaf | grep $REDIS_NAME | grep $REDIS_PORT | grep -v grep | awk '{print $2}'`
  
if [[ $PID != '' ]]; then
echo
echo "$REDIS_NAME $REDIS_PORT is running as $PID"
echo
exit
fi

$REDIS_HOME/bin/redis-server $REDIS_HOME/conf/$REDIS_CONF
