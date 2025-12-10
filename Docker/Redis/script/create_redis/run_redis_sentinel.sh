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

DEFAULTPATH=`pwd`

# Create directory before container creation.
echo -e "What do you want redis instance name?"
read rdir

if [ -e ./redis/$rdir ];then echo check
	else mkdir -p /redis/$rdir/data /redis/$rdir/log /redis/$rdir/conf /redis/$rdir/work
fi

# Set the local path and container path.
LOCAL_CONTAINER_DATA="/redis/$rdir/data"
LOCAL_CONTAINER_LOG="/redis/$rdir/log"
LOCAL_CONTAINER_CONF="/redis/$rdir/conf"
LOCAL_CONTAINER_BACKUP="/redis/$rdir/work"

DOCKER_CONTAINER_DATA="/redis/data"
DOCKER_CONTAINER_LOG="/redis/log"
DOCKER_CONTAINER_CONF="/redis/conf"
DOCKER_CONTAINER_BACKUP="/redis/work"

# Run Dockerfile for to create docker container.
echo
echo -e "--------------------------------------------------------------------------------------"
echo -e "#This is your docker image list"
docker image ls
echo -e "--------------------------------------------------------------------------------------"
echo
echo -e "Please choose your container image and tag."
read dimage dtag
echo
echo -e "--------------------------------------------------------------------------------------"
docker run -itd --name $rdir --network host -v ${LOCAL_CONTAINER_DATA}:${DOCKER_CONTAINER_DATA} -v ${LOCAL_CONTAINER_LOG}:${DOCKER_CONTAINER_LOG} -v ${LOCAL_CONTAINER_CONF}:${DOCKER_CONTAINER_CONF} -v ${LOCAL_CONTAINER_BACKUP}:${DOCKER_CONTAINER_BACKUP} $dimage:$dtag /bin/bash
echo -e "--------------------------------------------------------------------------------------"
docker ps -a
echo -e "--------------------------------------------------------------------------------------"

# Check the Docker container Redis instance start and status.
echo -e "--------------------------------------------------------------------------------------"
echo Start docker redis instance.
docker exec $rdir ./redis_6379 start
echo -e "--------------------------------------------------------------------------------------"
echo -e "Show $rdir process list for redis."
docker exec $rdir ps -ef | grep redis 
echo -e "--------------------------------------------------------------------------------------"

# Change redis sentinel conf
# [Sentinel_Conf] Change the Bind(IP)
echo -e "# What do you want to change bind?"
read cbind

sed "s/^# bind 127.0.0.1 192.168.1.1/bind $cbind 127.0.0.1/g" /root/docker_redis/default/redis/sentinel.conf > /root/docker_redis/result/sentinel1.conf

# [Sentinel_Conf] Change the Port
echo -e "# What do you want to change the port?"
read cport

sed "s/port 26379/port $cport/g" /root/docker_redis/result/sentinel1.conf >> /root/docker_redis/result/sentinel2.conf

rm -rf /root/docker_redis/result/sentinel1.conf

# [Sentinel_Conf] Change the monitor setting
echo -e "# Setting the sentinel monitoring(master_IP master_port quorum)"
read mip mport mquo

sed "s/sentinel monitor mymaster 127.0.0.1 6379 2/sentinel monitor mymaster $mip $mport $mquo/g" /root/docker_redis/result/sentinel2.conf >> /root/docker_redis/result/sentinel3.conf

rm -rf /root/docker_redis/result/sentinel2.conf

# [Sentinel_Conf] Change setting the sentinel sdown time
echo -e "# Setting the sentinel sdown time"
read ctime
sed "s/sentinel down-after-milliseconds mymaster 30000/sentinel down-after-milliseconds mymaster $ctime/g" /root/docker_redis/result/sentinel3.conf >> /root/docker_redis/result/sentinel4.conf

rm -rf /root/docker_redis/result/sentinel3.conf

# [Sentinel_Conf] Change the default
sed "s/logfile change/logfile \/redis\/log\/sentinel_$cport.log/g" /root/docker_redis/result/sentinel4.conf >> /root/docker_redis/result/sentinel5.conf
rm -rf /root/docker_redis/result/sentinel4.conf

sed "s/dir \/tmp/dir \/redis\/data/g" /root/docker_redis/result/sentinel5.conf >> /root/docker_redis/result/sentinel6.conf
rm -rf /root/docker_redis/result/sentinel5.conf

sed "s/pidfile \/var\/run\/redis-sentinel.pid/pidfile \/redis\/data\/sentinel_$cport.pid/g" /root/docker_redis/result/sentinel6.conf >> /root/docker_redis/result/sentinel7.conf
rm -rf /root/docker_redis/result/sentinel6.conf

sed "s/^# protected-mode no/protected-mode yes/g" /root/docker_redis/result/sentinel7.conf >> /root/docker_redis/result/sentinel8.conf
rm -rf /root/docker_redis/result/sentinel7.conf

sed "s/daemonize no/daemonize yes/g" /root/docker_redis/result/sentinel8.conf >> /root/docker_redis/result/sentinel_$cport.conf
rm -rf /root/docker_redis/result/sentinel8.conf

# Move the redis conf
cp $DEFAULTPATH/result/sentinel_$cport.conf /redis/$rdir/conf/sentinel_$cport.conf

docker exec $rdir ./redis_6379 stop
docker exec $rdir mv redis_6379 redis_$cport
docker exec $rdir sed -i "s/EXEC=\/usr\/local\/bin\/redis-server/EXEC=\/usr\/local\/bin\/redis-sentinel/g" redis_$cport
docker exec $rdir sed -i "s/PIDFILE=\/var\/run\/redis_6379.pid/PIDFILE=\/redis\/data\/sentinel_$cport.pid/g" redis_$cport
docker exec $rdir sed -i "s/CONF=\"\/etc\/redis\/6379.conf\"/CONF=\"\/redis\/conf\/sentinel_$cport.conf\"/g" redis_$cport
docker exec $rdir sed -i "s/REDISPORT=\"6379\"/REDISPORT=\"$cport\"/g" redis_$cport

docker exec $rdir ./redis_$cport start

ps -ef | grep redis

sleep 2

docker exec $rdir redis-cli -h $cbind -p $cport info sentinel
