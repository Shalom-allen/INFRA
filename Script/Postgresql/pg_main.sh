#!/bin/bash
# --------------------------------------------------------------
#                      Postgresql
#                                       Ver. 1.0
#
#                                       Date 2026-01-14
#                                       Create by Yoo Min Sang
#                                       OS Version : Ubuntu 24.04
#                                       DBMS : Postgresql 14
# 특이사항
# 리눅스 기반에서 수행 시 아래 명령어 수행(Unix 파일 변환)
# apt install -y dos2unix
# chmod +x pg_main.sh
# dos2unix pg_main.sh
# 
# 명령어
# 날짜 변환 : timedatectl set-timezone 'Asia/Seoul'
# --------------------------------------------------------------
#timedatectl set-timezone 'Asia/Seoul'
clear

# 시간함수 & Log 파일 설정 --첫 실행 시 Log 디렉토리 설정
now() {
    date '+%Y-%m-%d %H:%M:%S'
}

echo "Where is the script's home directory?"
read H_LOC
        
L_DIR="/media/sf_shell/Script/Script_Log"
L_DATE=$(date '+%Y%m%d%H%M%S')
L_USER=$(whoami)
L_NAME="${L_DIR}/${L_DATE}_${L_USER}.log"

# 스크립트 시작로그
echo "Start Postgresql Script" >> $L_NAME
echo "$(whoami) / $(now)" >> $L_NAME
clear

# 작업 선택
while true; do
    clear
    echo "--------------------------------------------------------------------------------------"
    echo "Welcome to the PostgreSQL installer."
    echo "Please select the task you want to perform."
    echo 
    echo "1) Package Update"
    echo "2) Install Postgresql"
    echo "3) Check Postgresql Status"
    echo "4) Set up PostgreSQL replication (requires at least two DB servers => not currently supported)."
    echo "5) Postgresql Management"
    echo "6) End of work"
    echo "--------------------------------------------------------------------------------------"
    read -p "Select [1-6]: " CHOICE
    clear

    case "$CHOICE" in
      1)
        # 패키지 업데이트
        echo "You selected number $CHOICE."
        apt install -y vim net-tools openssh-server dos2unix
        clear

        apt-get update -y
        echo "$(whoami) / $(now) : Task $CHOICE completed" >> $L_NAME
        echo "Download Is Complete"
        ;;
      2)
        # Postgresql 설치
        echo "You selected number $CHOICE."
        echo "Start installing PostgreSQL"
        echo "$(whoami) / $(now) : Start installing PostgreSQL" >> $L_NAME

        source $H_LOC/script/pg_install.sh

        echo "PostgreSQL installation complete"
        echo "$(whoami) / $(now) : PostgreSQL installation complete" >> $L_NAME
        sleep 3
        ;;
      3)
        # Postgresql 상태확인
        echo "You selected number $CHOICE."
        STATE=$(systemctl show postgresql -p ActiveState --value)
        TS=$(systemctl show postgresql -p ActiveEnterTimestamp --value)
        echo "$(whoami) / $(now) : Postgresql status : ${STATE} ( ${TS} )" >> $L_NAME
        echo "$(whoami) / $(now) : Task $CHOICE completed" >> $L_NAME
        echo "Postgresql status : ${STATE} ( ${TS} )"
        sudo -i -u postgres psql --version
        sleep 3
        ;;
      4)
        # Postgresql Replication
        echo "You selected number $CHOICE."
        echo "Not Currently Supported"
        sleep 3
        ;;
      5)
        # Postgresql 관리
        echo "You selected number $CHOICE."
        echo "Start PostgreSQL Management"
        echo "$(whoami) / $(now) : Start PostgreSQL Management" >> $L_NAME

        source $H_LOC/script/pg_admin.sh

        echo "PostgreSQL management completed"
        echo "$(whoami) / $(now) : PostgreSQL management completed" >> $L_NAME
        sleep 3
        ;;
      6)
        # 작업 종료
        echo "You selected number $CHOICE."
        echo "Bye, $(whoami)"
        echo "$(whoami) / $(now) : Termination by choice" >> $L_NAME
        sleep 2
        exit
        ;;
      *)
        echo "NO selected. Please select again."
        sleep 2
        ;;
    esac
done

# history 삭제
history -c