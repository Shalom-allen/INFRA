#!/bin/bash
# --------------------------------------------------------------
#                   Install Postgresql
#                                       Ver. 1.0
#
#                                       Date 2026-01-14
#                                       Create by Yoo Min Sang
#                                       OS Version : Ubuntu 22.04
#                                       DBMS : Postgresql 14
# 특이사항
# 리눅스 기반에서 수행 시 아래 명령어 수행(Unix 파일 변환)
# apt install -y dos2unix
# chmod +x pg_controler.sh
# dos2unix pg_controler.sh
# 
# 날짜 변환 : timedatectl set-timezone 'Asia/Seoul'
# --------------------------------------------------------------

# 시간함수 & Log 파일 설정 --첫 실행 시 Log 디렉토리 설정
now() {
    date '+%Y-%m-%d %H:%M:%S'
}

L_DIR="/media/sf_shell/Script/Script_Log"
L_DATE=$(date '+%Y%m%d%H%M%S')
L_USER=$(whoami)
L_NAME="${L_DIR}/${L_DATE}_${L_USER}.log"

# 스크립트 시작로그
echo "Start package installation" >> $L_NAME
echo "$(whoami) / $(now)" >> $L_NAME
clear

# 작업 선택
while true; do
    clear
    echo "--------------------------------------------------------------------------------------"
    echo "Welcome to the PostgreSQL installer."
    echo "Please select the task you want to perform."
    echo 
    echo "1) Package Update => Press Enter when you are done"
    echo "2) Package installation (including DBMS installation) => Press Enter when you are done"
    echo "3) Check Postgresql status"
    echo "4) Change the PostgreSQL configuration file (this will shut down the running DBMS)."
    echo "5) Set up PostgreSQL replication (requires at least two DB servers => not currently supported)."
    echo "6) End of work"
    echo "--------------------------------------------------------------------------------------"
    read -p "Select [1-6]: " CHOICE
    clear

    case "$CHOICE" in
      1)
        # 패키지 업데이트
        echo "You selected number $CHOICE."
        apt-get update -y
        echo "$(now) / Task $CHOICE completed" >> $L_NAME
        echo "Download Is Complete"
        ;;
      2)
        # 필요 패키지 설치 및 Postgresql 설치
        echo "You selected number $CHOICE."
        apt-get install -y vim net-tools openssh-server dos2unix postgresql-16 postgresql-contrib
        echo "$(now) / Task $CHOICE completed" >> $L_NAME
        echo "Download Is Complete"
        ;;
      3)
        # Postgresql 상태확인
        echo "You selected number $CHOICE."
        STATE=$(systemctl show postgresql -p ActiveState --value)
        TS=$(systemctl show postgresql -p ActiveEnterTimestamp --value)
        echo "Postgresql status : ${STATE} ( ${TS} )" >> $L_NAME
        echo "$(now) / Task $CHOICE completed" >> $L_NAME
        echo "Postgresql status : ${STATE} ( ${TS} )"
        psql --version
        sleep 3
        ;;
      4)
        # Postgresql 설정파일 변경
        echo "You selected number $CHOICE."
        echo "Please tell me the location of the postgresql configuration file."
        echo
        read -p "File Location : " LOC_CONF

        if [[ ! -f "$LOC_CONF" ]]; then
          echo "ERROR: File not found."
          echo $LOC_CONF
          exit
        fi

        systemctl stop postgresql
        STATE=$(systemctl show postgresql -p ActiveState --value)
        TS=$(systemctl show postgresql -p ActiveEnterTimestamp --value)
        echo "Postgresql status : ${STATE} ( ${TS} )"
        echo "$(now) / Task $CHOICE completed" >> $L_NAME
        echo "Postgresql status : ${STATE} ( ${TS} )" >> $L_NAME

        while true; do
          clear
          echo "--------------------------------------------------------------------------------------"
          echo "Which part of the Postgresql configuration file would you like to change?"
          echo 
          echo "1) Change port"
          echo "2) Change max_connections"
          echo "3) Change shared_buffers"
          echo "4) End of work"
          echo "--------------------------------------------------------------------------------------"
          read -p "Select [1-4]: " P_CHOICE
          clear

          case "$P_CHOICE" in
            1)
              echo "The number selected in the Posgresql setup task is $P_CHOICE."
              N_PORT=$(grep -E '^[[:space:]]*port[[:space:]]*=' "$LOC_CONF" | sed -E 's/.*=[[:space:]]*([0-9]+).*/\1/')
              echo "The currently set port is $N_PORT"
              echo "Please tell me the port number to change"
              read -p "Change port: " C_PORT

              sed -i "s/^port[[:space:]]*=[[:space:]]*$N_PORT/port = $C_PORT/" "$LOC_CONF"

              echo "Port change from $N_PORT -> $C_PORT has been completed." >> $L_NAME
              sleep 3
              ;;
            2)
              echo "The number selected in the Posgresql setup task is $P_CHOICE."
              MC=$(grep -E '^[[:space:]]*max_connections[[:space:]]*=' "$LOC_CONF" | sed -E 's/.*=[[:space:]]*([0-9]+).*/\1/')
              echo "The currently set max_connections is $MC"
              echo "Please tell me the max_connections to change"
              read -p "Change max_connections: " C_MC

              sed -i -E "s|^[[:space:]]*max_connections[[:space:]]*=[[:space:]]*[0-9]+|max_connections = $C_MC|" "$LOC_CONF"

              echo "Max Connections change from $MC -> $C_MC has been completed." >> $L_NAME
              sleep 3
              ;;
            3)
              echo "The number selected in the Posgresql setup task is $P_CHOICE."
              N_MEM=$(free -h | awk '/^Mem:/ {sub(/i/, "", $2); print $2}')
              N_BUF=$(grep -E '^[[:space:]]*shared_buffers[[:space:]]*=' "$LOC_CONF" | sed -E 's/.*=[[:space:]]*([0-9]+).*/\1/')
              echo "Current total memory capacity : $N_MEM"
              echo "Current buffer settings : $N_BUF"
              read -p "Change shared_buffers: " C_BUF

              sed -i -E "s|^[[:space:]]*shared_buffers[[:space:]]*=[[:space:]]*[0-9]+|shared_buffers = $C_BUF|" "$LOC_CONF"

              echo "Shared Buffers change from $N_BUF -> $C_BUF has been completed." >> $L_NAME
              sleep 3
              ;;
            4)
              echo "The number selected in the Posgresql setup task is $P_CHOICE."
              echo "We will complete the Posgresql setup."
              echo "$(now) / Complete the Posgresql setup task" >> $L_NAME
              sleep 3
              break
              ;;
            *)
              echo "No number was selected in the Posgresql configuration task. Please select again."
              sleep 3
              ;;
          esac
        done

        systemctl start postgresql
        echo "Postgresql status : ${STATE} ( ${TS} )"

        echo "Postgresql configuration file setup complete" >> $L_NAME
        ;;
      5)
        echo "You selected number $CHOICE."
        echo "Not Currently Supported"
        sleep 3
        ;;
      6)
        echo "You selected number $CHOICE."
        echo "Bye, $(whoami)"
        echo "$(now) / Termination by choice" >> $L_NAME
        sleep 3
        exit
        ;;
      *)
        echo "NO selected. Please select again."
        sleep 3
        ;;
    esac
done