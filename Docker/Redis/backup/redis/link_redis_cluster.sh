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

# Docker Container Search
echo "==========================================================================================="
docker ps
echo "==========================================================================================="
echo "Set the container to run the Redis create command."
read cname
echo "==========================================================================================="

# Redis cluster IP settings
echo "==========================================================================================="
echo "Enter the IP of the Redis cluster node you want to configure.(Redis cluster with 3 master nodes)"
read ip1 ip2 ip3 ip4 ip5 ip6

# Redis cluster Port settings
echo "Enter the Port of the Redis cluster node you want to configure.(Redis cluster with 3 master nodes)"
read port1 port2 port3 port4 port5 port6

# Specify the number of Redis cluster slaves.
# echo "Specify the number of slave nodes of the Redis cluster master node."
# read slaves
echo "==========================================================================================="

# Command Execution.
docker exec -it $cname redis-cli --cluster create $ip1:$port1 $ip2:$port2 $ip3:$port3 $ip5:$port5 $ip4:$port4 $ip6:$port6 --cluster-replicas 1

# Redis Cluster Node Check
# docker exec $cname redis-cli --cluster check $ip1:$port1
