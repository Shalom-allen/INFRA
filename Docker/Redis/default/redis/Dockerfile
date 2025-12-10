# Install Centos 7
FROM centos:7

# Create Directory
RUN mkdir -p /redis/backup
RUN mkdir -p /redis/conf
RUN mkdir -p /redis/data
RUN mkdir -p /redis/log

# Install Package
RUN yum update -y && yum install wget gcc gcc-c++ make -y

# Install Redis 6.2.5 
RUN wget http://download.redis.io/releases/redis-6.2.5.tar.gz
RUN tar -xvf redis-6.2.5.tar.gz -C /redis
WORKDIR /redis/redis-6.2.5
RUN make
RUN make install
WORKDIR /redis/redis-6.2.5/utils
RUN ./install_server.sh 
WORKDIR /etc/init.d/
