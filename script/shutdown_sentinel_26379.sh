#!/bin/sh
  
REDIS_HOME=/sw/home/redis
REDIS_NAME=redis-sentinel
REDIS_PORT=26379
 
if [ -z "`ps -eaf | grep $REDIS_NAME | grep $REDIS_PORT  | grep -v grep`" ]; then
    echo "Redis Sentinel was not started."
else
    $REDIS_HOME/bin/redis-cli -p $REDIS_PORT shutdown
    echo "Redis Sentinel is shutdowned."
fi
