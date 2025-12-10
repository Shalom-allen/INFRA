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

# Meet Cluster Container
echo -e "================================================================================================"
echo -e "Docker Container List. Choose contanier name for redis cluster"
docker ps -a
echo -e "================================================================================================"
echo Write the container name of 3 nodes to connect the cluster.
read cname1 cname2 cname3

echo -e "[Master] Write the IP of the 3 nodes to connect the cluster."
read mip1 mip2 mip3 

echo -e "[Master] Write the port of the 3 nodes to connect the cluster."
read mport1 mport2 mport3

echo -e "================================================================================================"
echo -e "Choose contanier IP, port for redis cluster"
ps -ef | grep redis
echo -e "================================================================================================"

echo -e "[Slave] Write the IP of the 3 nodes to connect the cluster."
read sip1 sip2 sip3

echo -e "[Slave] Write the port of the 3 nodes to connect the cluster."
read sport1 sport2 sport3

docker exec $cname1 redis-cli --cluster add-node $sip1:$sport1 $mip1:$mport1 --cluster-slave
docker exec $cname2 redis-cli --cluster add-node $sip2:$sport2 $mip2:$mport2 --cluster-slave
docker exec $cname3 redis-cli --cluster add-node $sip3:$sport3 $mip3:$mport3 --cluster-slave

# Check the Redis Cluster
docker exec $cname1 redis-cli --cluster check $sip1:$sport1

