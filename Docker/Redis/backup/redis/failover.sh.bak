echo -e "# Docker Container List."
docker ps -a
echo -e "================================================================================================"
echo -e "# Redis Process List"
ps -ef | grep redis
echo -e "================================================================================================"
echo -e "Enter the Docker container information you want to compare.(container, ip, port)"
read cname cip cport
docker exec $cname redis-cli --cluster check $cip:$cport
echo -e "================================================================================================"

echo -e "Please enter the information of the node you want to failover.(container, ip, port)"
read name ip port
docker exec $name redis-cli -h $ip -p $port cluster failover

docker exec $name redis-cli --cluster check $ip:$port

