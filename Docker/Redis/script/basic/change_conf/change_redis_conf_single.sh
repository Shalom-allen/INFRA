#!/bin/bash
# --------------------------------------------------------------
#       Docker & Redis Control
#                                        Ver. 1.0
#
#                                        Date 2021-11-09
#                                Create by Yoo Min Sang
#
#
#
# --------------------------------------------------------------

# [Redis_Conf] Set the container path.
DOCKER_CONTAINER_DATA="/redis/data"
DOCKER_CONTAINER_LOG="/redis/log"
DOCKER_CONTAINER_CONF="/redis/conf"

# [Redis_Conf] Change the Bind(IP)
echo -e "What do you want to change bind?"
read cbind

sed "s/bind 127.0.0.1 -::1/bind $cbind 127.0.0.1 -::1/g" /root/docker_redis/default/redis/redis.conf > /root/docker_redis/result/redis1.conf

# [Redis_Conf] Change the Port
echo -e "What do you want to change the port?"
read cport

sed "s/port 6379/port $cport/g" /root/docker_redis/result/redis1.conf >> /root/docker_redis/result/redis2.conf

rm -rf /root/docker_redis/result/redis1.conf

# [Redis_Conf] Change the Logfile
sed "s/logfile \/var\/log\/redis_6379.log/logfile \/redis\/log\/redis_$cport.log/g" /root/docker_redis/result/redis2.conf >> /root/docker_redis/result/redis3.conf

rm -rf /root/docker_redis/result/redis2.conf

# [Redis_Conf] Change the Datadir
sed "s/dir \/var\/lib\/redis\/6379/dir \/redis\/data/g" /root/docker_redis/result/redis3.conf >> /root/docker_redis/result/redis4.conf

rm -rf /root/docker_redis/result/redis3.conf

sed "s/pidfile \/var\/run\/redis_6379.pid/pidfile \/redis\/data\/redis_$cport.pid/g" /root/docker_redis/result/redis4.conf >> /root/docker_redis/result/redis_$cport.conf

rm -rf /root/docker_redis/result/redis4.conf
