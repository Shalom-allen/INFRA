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

# [Sentinel_Conf] Set the container path.
DOCKER_CONTAINER_DATA="/redis/data"
DOCKER_CONTAINER_LOG="/redis/log"
DOCKER_CONTAINER_CONF="/redis/conf"

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



