# Update the default file.
echo -e "Docker Container List."
docker ps -a
echo -e "================================================================================================"
echo -e "Redis Process List"
ps -ef | grep redis
echo -e "================================================================================================"
echo -e "Enter the Docker container information(3 node container)"
read dname1 dname2 dname3
echo -e "Enter the Docker container information(3 node ip)"
read dip1 dip2 dip3
echo -e "Enter the Docker container information(3 nodde port)"
read dport1 dport2 dport3

# node 1
docker exec $dname1 redis-cli --cluster check $dip1:$dport1 > /redis/$dname1/work/node1_1.txt
cat /redis/$dname1/work/node1_1.txt | cut -d '>' -f 1 | cut -d '[' -f 1 > /redis/$dname1/work/node1_2.txt
rm -rf /redis/$dname1/work/node1_1.txt
sed '1,6d' /redis/$dname1/work/node1_2.txt > /redis/$dname1/work/node1_3.txt
rm -rf /redis/$dname1/work/node1_2.txt
sed -i '/1 additional/d' /redis/$dname1/work/node1_3.txt
sed -i '/slots:/d' /redis/$dname1/work/node1_3.txt
sed -i '/replicates/d' /redis/$dname1/work/node1_3.txt
sort /redis/$dname1/work/node1_3.txt | sort -k 3 > /redis/$dname1/work/node1_4.txt
rm -rf /redis/$dname1/work/node1_3.txt
sed '1,4d' /redis/$dname1/work/node1_4.txt > /redis/$dname1/work/cluster_node_status_default.txt
rm -rf /redis/$dname1/work/node1_4.txt

# node 2
docker exec $dname2 redis-cli --cluster check $dip2:$dport2 > /redis/$dname2/work/node2_1.txt
cat /redis/$dname2/work/node2_1.txt | cut -d '>' -f 1 | cut -d '[' -f 1 > /redis/$dname2/work/node2_2.txt
rm -rf /redis/$dname2/work/node2_1.txt
sed '1,6d' /redis/$dname2/work/node2_2.txt > /redis/$dname2/work/node2_3.txt
rm -rf /redis/$dname2/work/node2_2.txt
sed -i '/1 additional/d' /redis/$dname2/work/node2_3.txt
sed -i '/slots:/d' /redis/$dname2/work/node2_3.txt
sed -i '/replicates/d' /redis/$dname2/work/node2_3.txt
sort /redis/$dname2/work/node2_3.txt | sort -k 3 > /redis/$dname2/work/node2_4.txt
rm -rf /redis/$dname2/work/node2_3.txt
sed '1,4d' /redis/$dname2/work/node2_4.txt > /redis/$dname2/work/cluster_node_status_default.txt
rm -rf /redis/$dname2/work/node2_4.txt

# node 3
docker exec $dname3 redis-cli --cluster check $dip3:$dport3 > /redis/$dname3/work/node3_1.txt
cat /redis/$dname3/work/node3_1.txt | cut -d '>' -f 1 | cut -d '[' -f 1 > /redis/$dname3/work/node3_2.txt
rm -rf /redis/$dname3/work/node3_1.txt
sed '1,6d' /redis/$dname3/work/node3_2.txt > /redis/$dname3/work/node3_3.txt
rm -rf /redis/$dname3/work/node3_2.txt
sed -i '/1 additional/d' /redis/$dname3/work/node3_3.txt
sed -i '/slots:/d' /redis/$dname3/work/node3_3.txt
sed -i '/replicates/d' /redis/$dname3/work/node3_3.txt
sort /redis/$dname3/work/node3_3.txt | sort -k 3 > /redis/$dname3/work/node3_4.txt
rm -rf /redis/$dname3/work/node3_3.txt
sed '1,4d' /redis/$dname3/work/node3_4.txt > /redis/$dname3/work/cluster_node_status_default.txt
rm -rf /redis/$dname3/work/node3_4.txt

