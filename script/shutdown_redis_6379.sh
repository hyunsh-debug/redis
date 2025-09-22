#!/bin/sh
  
REDIS_HOME=/sw/home/redis
REDIS_NAME=redis-server
REDIS_PORT=6379
 
if [ -z "`ps -eaf | grep $REDIS_NAME | grep $REDIS_PORT  | grep -v grep`" ]; then
    echo "Redis was not started."
else
    $REDIS_HOME/bin/redis-cli -p $REDIS_PORT -a test@123 shutdown
    echo "Redis is shutdowned."
fi
