#!/bin/bash
# --------------------------------------------------------------------------------------
#                   Install Postgresql
#                                       Ver. 1.0
#
#                                       Date 2026-01-08
#                                       Create by Yoo Min Sang
#                                       OS Version : Ubuntu 22.04
#                                       DBMS : Postgresql 14.20 -> 변경될 수 있음
# --------------------------------------------------------------------------------------

# 패키지 업데이트 및 설치
echo "--------------------------------------------------------------------------------------"
echo "Package Setting"
apt-get install -y vim net-tools openssh-server postgresql postgresql-contrib
apt-get update -y
echo "--------------------------------------------------------------------------------------"

# Postgresql 상태 확인
echo "Checked PostgreSQL Status"
STATE=$(systemctl show postgresql -p ActiveState --value)
TS=$(systemctl show postgresql -p ActiveEnterTimestamp --value)
echo "Postgresql status : ${STATE} ( ${TS} )"
psql --version
echo "--------------------------------------------------------------------------------------"
