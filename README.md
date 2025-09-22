# Redis 설치 및 구성

### 환경

- OS: CentOS 7.9
- HOME_DIR: /sw/home/redis
- Redis-version: 7.4.5
- Redis-HA: replication(master-salve) + sentinel

### 설치

1. 사전작업

   1. cd /sw/home/redis
   2. mkdir logs script pid data conf

2. 소스 설치

   1. wget https://download.redis.io/releases/redis-7.4.5.tar.gz

3. 컴파일 및 설치

   1. tar xvf redis-7.4.5.tar.gz
   2. cd redis-7.4.5
   3. make && make install PREFIX=/sw/home/redis

4. config 파일 복사

   1. mv redis.conf ../conf/redis_master_6379.conf
   2. mv redis.conf ../conf/redis_slave_6379.conf
   3. mv sentinel.conf ../conf/redis_master_6379.conf

5. 임시 디렉토리 삭제
   1. cd /sw/home/redis
   2. rm -rf temp

### 기동 및 중지 스크립트

#### redis 기동(startup_redis_6379.sh)

```sh
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

```

#### redis 중지(shutdown_redis_6379.sh)

```sh
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

```

#### sentinel 중지(startup_sentinel_26379)

```sh
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

```

#### sentinel 중지(shutdown_sentinel_26379)

```sh
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

```

### config

#### master 노드

```
bind 127.0.0.1 #ip 추가
bind-source-addr #ip 추가
protected-mode yes
daemonize yes
pidfile /sw/home/redis/pid/redis_6379.pid # pid 파일 경로
logfile /sw/home/redis/logs/redis_6379.log # log 파일 경로
dir /sw/home/redis/data
requirepass test@123 #redis password
```

#### slave 노드

```
bind 127.0.0.1 #ip 추가
bind-source-addr #ip 추가
protected-mode yes
daemonize yes
pidfile /sw/home/redis/pid/redis_6379.pid # pid 파일 경로
logfile /sw/home/redis/logs/redis_6379.log # log 파일 경로
dir /sw/home/redis/data
replicaof # master노드 ip port
masterauth # 마스터 노드 requirepass
requirepass test@123 #redis password
```

#### sentinel

```
bind 127.0.0.1 # ip 추가
pidfile /sw/home/redis/pid/sentinel_26379.pid # pid 파일 경로
logfile /sw/home/redis/logs/sentinel_26379.log # log 파일 경로
dir /sw/home/redis/data # data 파일 경로
sentinel monitor mymaster # 마스터 노드 ip port quorum
sentinel auth-pass mymaster test@123 # 마스터 노드 requirepass
```
