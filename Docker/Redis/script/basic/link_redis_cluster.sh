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
echo "Enter the IP of the Redis cluster node you want to configure.(Redis cluster with 3 master nodes)"
read ip1 ip2 ip3 ip4 ip5 ip6

# Redis cluster Port settings
echo "Enter the Port of the Redis cluster node you want to configure.(Redis cluster with 3 master nodes)"
read port1 port2 port3 port4 port5 port6
echo "==========================================================================================="

# Redis Cluster Master Node Setup
docker exec $cname redis-cli -h $ip1 -p $port1 cluster meet $ip1 $port1
docker exec $cname redis-cli -h $ip2 -p $port2 cluster meet $ip1 $port1
docker exec $cname redis-cli -h $ip3 -p $port3 cluster meet $ip1 $port1

# Redis Cluster Master Node Socket Setup
echo -e "Sockets are automatically distributed in increments of 5461."
docker exec $cname redis-cli -h $ip1 -p $port1 cluster addslots {0..5461}
docker exec $cname redis-cli -h $ip2 -p $port2 cluster addslots {5462..10922}
docker exec $cname redis-cli -h $ip3 -p $port3 cluster addslots {10923..16383}

sleep 2
echo "==========================================================================================="

# Redis Cluster Slave Node Setup
docker exec $cname redis-cli --cluster add-node $ip4:$port4 $ip1:$port1 --cluster-slave
docker exec $cname redis-cli --cluster add-node $ip5:$port5 $ip2:$port2 --cluster-slave
docker exec $cname redis-cli --cluster add-node $ip6:$port6 $ip3:$port3 --cluster-slave
echo "==========================================================================================="

# Redis Cluster Check.
docker exec $cname redis-cli --cluster check $ip1:$port1

# Redis Cluster default node status
docker exec $cname redis-cli --cluster check $ip1:$port1 > /redis/$cname/work/node1_1.txt
cat /redis/$cname/work/node1_1.txt | cut -d '>' -f 1 | cut -d '[' -f 1 > /redis/$cname/work/node1_2.txt
rm -rf /redis/$cname/work/node1_1.txt
sed '1,6d' /redis/$cname/work/node1_2.txt > /redis/$cname/work/node1_3.txt
rm -rf /redis/$cname/work/node1_2.txt
sed -i '/1 additional/d' /redis/$cname/work/node1_3.txt
sed -i '/slots:/d' /redis/$cname/work/node1_3.txt
sed -i '/replicates/d' /redis/$cname/work/node1_3.txt
sort /redis/$cname/work/node1_3.txt | sort -t ":" -k 3 > /redis/$cname/work/node1_4.txt
rm -rf /redis/$cname/work/node1_3.txt
sed '1,4d' /redis/$cname/work/node1_4.txt > /redis/$cname/work/cluster_node_status_default.txt
rm -rf /redis/$cname/work/node1_4.txt

