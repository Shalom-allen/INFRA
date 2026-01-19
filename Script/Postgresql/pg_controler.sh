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
    echo "1) Package Update"
    echo "2) Package installation (including DBMS installation)"
    echo "3) Check Postgresql status"
    echo "4) Resetting Postgresql (first run after installing the library)"
    echo "5) Change the PostgreSQL configuration file (this will shut down the running DBMS)."
    echo "6) Set up PostgreSQL replication (requires at least two DB servers => not currently supported)."
    echo "7) Postgresql Management"
    echo "8) End of work"
    echo "--------------------------------------------------------------------------------------"
    read -p "Select [1-8]: " CHOICE
    clear

    case "$CHOICE" in
      1)
        # 패키지 업데이트
        echo "You selected number $CHOICE."
        apt-get update -y
        echo "$(whoami) / $(now) : Task $CHOICE completed" >> $L_NAME
        echo "Download Is Complete"
        ;;
      2)
        # 필요 패키지 설치 및 Postgresql 설치
        echo "You selected number $CHOICE."
        timedatectl set-timezone 'Asia/Seoul'
        apt-get install -y vim net-tools openssh-server dos2unix postgresql-16 postgresql-contrib
        echo "$(whoami) / $(now) : Task $CHOICE completed" >> $L_NAME
        echo "Download Is Complete"
        ;;
      3)
        # Postgresql 상태확인
        echo "You selected number $CHOICE."
        STATE=$(systemctl show postgresql -p ActiveState --value)
        TS=$(systemctl show postgresql -p ActiveEnterTimestamp --value)
        echo "$(whoami) / $(now) : ostgresql status : ${STATE} ( ${TS} )" >> $L_NAME
        echo "$(whoami) / $(now) : Task $CHOICE completed" >> $L_NAME
        echo "Postgresql status : ${STATE} ( ${TS} )"
        psql --version
        sleep 3
        ;;
      4)
        # Postgresql 재설정
        echo "You selected number $CHOICE."
        echo "Postgresql is shutting down"
        systemctl stop postgresql
        sleep 3
        clear

        echo "Please enter the data path for Postgresql."
        read D_LOC

        if [[ ! -f "$D_LOC" ]]; then
          echo "The path does not exist. A path will be created automatically."
          mkdir -p $D_LOC
          chown -R postgres:postgres $D_LOC
          chmod 700 $D_LOC
        fi

        echo "Please enter the wal path for Postgresql."
        read W_LOC

        if [[ ! -f "$W_LOC" ]]; then
          echo "The path does not exist. A path will be created automatically."
          mkdir -p $W_LOC
          chown -R postgres:postgres $W_LOC
          chmod 700 $W_LOC
        fi

        chown -R postgres:postgres $D_LOC $W_LOC
        chmod 700 $D_LOC $W_LOC

        sudo -u postgres /usr/lib/postgresql/16/bin/initdb -D $D_LOC --waldir=$W_LOC --encoding=UTF8
        sudo -u postgres /usr/lib/postgresql/16/bin/pg_ctl -D $D_LOC -l $D_LOC/install_$L_DATE.log start
        systemctl daemon-reload
        systemctl restart postgresql

        systemctl status postgresql
        sudo -u postgres psql -U postgres -c "show data_directory;"
        sudo -u postgres psql -U postgres -c "show hba_file;"
        sudo -u postgres psql -U postgres -c "show config_file;"

        echo "$(whoami) / $(now) : PostgreSQL reset operation completed" >> $L_NAME

        sleep 5
        ;;
      5)
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
        echo "$(whoami) / $(now) : Task $CHOICE completed" >> $L_NAME
        echo "$(whoami) / $(now) : Postgresql status : ${STATE} ( ${TS} )" >> $L_NAME

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
              N_PORT=$(grep -E '^[[:space:]]*#?[[:space:]]*port[[:space:]]*=' $LOC_CONF | sed -E 's/.*=[[:space:]]*([0-9]+).*/\1/')
              echo "The currently set port is $N_PORT"
              echo "Please tell me the port number to change"
              read -p "Change port: " C_PORT

              sed -i -E "s/^[[:space:]]*#?[[:space:]]*port[[:space:]]*=[[:space:]]*[0-9]+/port = $C_PORT/" $LOC_CONF

              echo "$(whoami) / $(now) : Port change from $N_PORT -> $C_PORT has been completed." >> $L_NAME
              sleep 3
              ;;
            2)
              echo "The number selected in the Posgresql setup task is $P_CHOICE."
              MC=$(grep -E '^[[:space:]]*max_connections[[:space:]]*=' "$LOC_CONF" | sed -E 's/.*=[[:space:]]*([0-9]+).*/\1/')
              echo "The currently set max_connections is $MC"
              echo "Please tell me the max_connections to change"
              read -p "Change max_connections: " C_MC

              sed -i -E "s|^[[:space:]]*max_connections[[:space:]]*=[[:space:]]*[0-9]+|max_connections = $C_MC|" "$LOC_CONF"

              echo "$(whoami) / $(now) : Max Connections change from $MC -> $C_MC has been completed." >> $L_NAME
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

              echo "$(whoami) / $(now) : Shared Buffers change from $N_BUF -> $C_BUF has been completed." >> $L_NAME
              sleep 3
              ;;
            4)
              echo "The number selected in the Posgresql setup task is $P_CHOICE."
              echo "We will complete the Posgresql setup."
              echo "$(whoami) / $(now) : Complete the Posgresql setup task" >> $L_NAME
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

        echo "$(whoami) / $(now) : Postgresql configuration file setup complete" >> $L_NAME
        ;;
      6)
        # Postgresql Replication
        echo "You selected number $CHOICE."
        echo "Not Currently Supported"
        sleep 3
        ;;
      7)
        # Postgresql 관리
        echo "You selected number $CHOICE."

        while true; do
          clear
          echo "--------------------------------------------------------------------------------------"
          echo "Please select the task you want to perform in Postgresql."
          echo
          echo "1) Shutdown Posgresql"
          echo "2) Start Postgresql"
          echo "3) Restart Postgresql"
          echo "4) End of Work"
          echo "--------------------------------------------------------------------------------------"
          read -p "Select [1-4]: " W_CHOICE
          clear
          
          case "$W_CHOICE" in
          1)
            # Posgresql 종료
            echo "You selected number $W_CHOICE."
            echo "Shutdown Posgresql"
            systemctl stop postgresql
            systemctl status postgresql
            echo "$(whoami) / $(now) : Shutdown Posgresql" >> $L_NAME
            sleep 3
            ;;
          2)
            # Posgresql 시작
            echo "You selected number $W_CHOICE."
            echo "Start Posgresql"
            systemctl start postgresql
            systemctl status postgresql
            echo "$(whoami) / $(now) : Start Posgresql" >> $L_NAME
            sleep 3
            ;;
          3)
            # Posgresql 재시작
            echo "You selected number $W_CHOICE."
            echo "Start Posgresql"
            systemctl retart postgresql
            systemctl status postgresql
            echo "$(whoami) / $(now) : Restart Posgresql" >> $L_NAME
            sleep 3
            ;;
          4)
            # 작업 종료
            echo "You selected number $W_CHOICE."
            echo "End of Work"
            echo "$(whoami) / $(now) : PostgreSQL management tasks completed" >> $L_NAME
            sleep 3
            break
            ;;
          *)
            echo "No number was selected. Please select again."
            sleep 3
            ;;
          esac
        done

        sleep 3
        ;;
      8)
        # 작업 종료
        echo "You selected number $CHOICE."
        echo "Bye, $(whoami)"
        echo "$(whoami) / $(now) : Termination by choice" >> $L_NAME
        sleep 3
        exit
        ;;
      *)
        echo "NO selected. Please select again."
        sleep 3
        ;;
    esac
done

# history 삭제
history -c