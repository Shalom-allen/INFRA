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

# Update the default file.
echo -e "Docker Container List."
docker ps -a
echo -e "================================================================================================"
echo -e "Redis Process List"
ps -ef | grep redis
echo -e "================================================================================================"
echo -e "Enter the Docker container information(container ip port)"
read dname1 dip1 dport1

# node 1
docker exec $dname1 redis-cli --cluster check $dip1:$dport1 > /redis/$dname1/work/node1_1.txt
cat /redis/$dname1/work/node1_1.txt | cut -d '>' -f 1 | cut -d '[' -f 1 > /redis/$dname1/work/node1_2.txt
rm -rf /redis/$dname1/work/node1_1.txt
sed '1,6d' /redis/$dname1/work/node1_2.txt > /redis/$dname1/work/node1_3.txt
rm -rf /redis/$dname1/work/node1_2.txt
sed -i '/1 additional/d' /redis/$dname1/work/node1_3.txt
sed -i '/slots:/d' /redis/$dname1/work/node1_3.txt
sed -i '/replicates/d' /redis/$dname1/work/node1_3.txt
sort /redis/$dname1/work/node1_3.txt | sort -t ":" -k 3 > /redis/$dname1/work/node1_4.txt
rm -rf /redis/$dname1/work/node1_3.txt
sed '1,4d' /redis/$dname1/work/node1_4.txt > /redis/$dname1/work/cluster_node_status_default.txt
rm -rf /redis/$dname1/work/node1_4.txt

