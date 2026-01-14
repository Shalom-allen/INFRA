#!/bin/bash
# --------------------------------------------------------------
#                   Install Postgresql
#                                       Ver. 1.0
#
#                                       Date 2026-01-14
#                                       Create by Yoo Min Sang
#                                       OS Version : Ubuntu 22.04
#                                       DBMS : Postgresql 18
# --------------------------------------------------------------

# 시간함수
now() {
    date '+%Y-%m-%d %H:%M:%S'
}

# 패키지 업데이트 및 설치
echo "--------------------------------------------------------------------------------------"
echo "Start package installation" >> sc_postgresql.log
echo "$(whoami) / $(now)" >> sc_postgresql.log

echo "Package Setting"
apt-get install -y vim net-tools openssh-server postgresql-18 postgresql-contrib &
apt-get update -y &

echo "Complete package installation" >> sc_postgresql.log
echo "$(whoami) / $(now)" >> sc_postgresql.log
echo "--------------------------------------------------------------------------------------"

# Postgresql 상태 확인
echo "Checked PostgreSQL Status" >> sc_postgresql.log
echo "$(whoami) / $(now)" >> sc_postgresql.log
echo "Checked PostgreSQL Status"

STATE=$(systemctl show postgresql -p ActiveState --value)
TS=$(systemctl show postgresql -p ActiveEnterTimestamp --value)
echo "Postgresql status : ${STATE} ( ${TS} )"
echo "Postgresql status : ${STATE} ( ${TS} )" >> sc_postgresql.log
psql --version
echo "--------------------------------------------------------------------------------------"

# Postgresql Configure 파일 확인 및 설정
CN_FILE = "/etc/postgresql/14/main/postgresql.conf"

if [ -e $CN_FILE ]; then
    # Postgresql 종료 & 상태확인
    echo "postgresql shutdown start" >> sc_postgresql.log
    echo "$(whoami) / $(now)" >> sc_postgresql.log
    echo "Checked PostgreSQL Status"
    systemctl stop postgresql &
    echo "Checked PostgreSQL Status"
    echo "Postgresql status : ${STATE} ( ${TS} )"
    echo "Postgresql status : ${STATE} ( ${TS} )" >> sc_postgresql.log

    clear
    echo "--------------------------------------------------------------------------------------"
    read -p "Want to change postgresql default settings?" check
    echo "--------------------------------------------------------------------------------------"

    # Postgresql 포트 변경
    read

else

fi

