#####################################################################################
# Ubuntu DockerFile
# Version  : 22.04
# 작성자   : 유민상
# 작성일   : 2024-05-02
# 상세내역 : Ubuntu Docker File Image Edit
# 수정자   :
# 수정일   :
# 수정내역 :
#####################################################################################
#Ubuntu Image Instsall
FROM ubuntu:22.04

#Set TimeZone
ENV TZ=Asia/Seoul

#Create 'mysql' user
RUN groupadd mysql
RUN useradd -r -g mysql -s /bin/false mysql

#Package Install
RUN apt-get update && apt-get upgrade -y \
        && apt-get install -y init systemd \
        && apt-get install -y vim curl \
        && apt-get install -y net-tools iputils-ping \
        && apt-get install -y cron \
        && apt-get install -y cmake libssl-dev libboost-all-dev libncurses5-dev libncursesw5-dev pkg-config

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/sbin/init"]
