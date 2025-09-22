#!/bin/sh
  
REDIS_HOME=/sw/home/redis
REDIS_NAME=redis-sentinel
REDIS_PORT=26379
REDIS_CONF=sentinel_26379.conf
 
PID=`ps -eaf | grep $REDIS_NAME | grep $REDIS_PORT | grep -v grep | awk '{print $2}'`
  
if [[ $PID != '' ]]; then
echo
echo "$REDIS_NAME $REDIS_PORT is running as $PID"
echo
exit
fi
 
$REDIS_HOME/bin/redis-sentinel $REDIS_HOME/conf/$REDIS_CONF
