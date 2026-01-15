#!/bin/bash
# --------------------------------------------------------------
#                   Install Postgresql
#                                       Ver. 1.0
#
#                                       Date 2026-01-14
#                                       Create by Yoo Min Sang
#                                       OS Version : Ubuntu 22.04
#                                       DBMS : Postgresql 14
# --------------------------------------------------------------

# 시간함수
now() {
    date '+%Y-%m-%d %H:%M:%S'
}

# 스크립트 시작로그
echo "Start package installation" >> sc_postgresql.log
echo "$(whoami) / $(now)" >> sc_postgresql.log
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
    echo "4) Change the PostgreSQL configuration file (this will shut down the running DBMS)."
    echo "5) Set up PostgreSQL replication (requires at least two DB servers => not currently supported)."
    echo "6) End of work"
    echo "--------------------------------------------------------------------------------------"
    read -p "Select [1-6]: " CHOISE
    clear

    case "$CHOISE" in
      1)
        # 패키지 업데이트
        echo "You selected number $CHOISE."
        apt-get update -y &
        echo "$(now) / Task $CHOISE completed" >> sc_postgresql.log
        continue
        ;;
      2)
        # 필요 패키지 설치 및 Postgresql 설치
        echo "You selected number $CHOISE."
        apt-get install -y vim net-tools openssh-server postgresql-18 postgresql-contrib &
        echo "$(now) / Task $CHOISE completed" >> sc_postgresql.log
        continue
        ;;
      3)
        # Postgresql 상태확인
        echo "You selected number $CHOISE."
        STATE=$(systemctl show postgresql -p ActiveState --value)
        TS=$(systemctl show postgresql -p ActiveEnterTimestamp --value)
        echo "Postgresql status : ${STATE} ( ${TS} )"
        echo "Postgresql status : ${STATE} ( ${TS} )" >> sc_postgresql.log
        echo "$(now) / Task $CHOISE completed" >> sc_postgresql.log
        continue
        ;;
      4)
        # Postgresql 설정파일 변경
        echo "You selected number $CHOISE."
        echo "Please tell me the location of the postgresql configuration file."
        echo
        read -p "File Location" LOC_CONF

        if [[ ! -f "$LOC_CONF" ]]; then
          echo "ERROR: File not found."
          echo $LOC_CONF
          exit 1
        fi

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
          read -p "Select [1-4]: " P_CHOISE
          clear

          case "$P_CHOISE" in
            1)
              echo "The number selected in the Posgresql setup task is $P_CHOISE."
              N_PORT=$(grep -E '^[[:space:]]*port[[:space:]]*=' "$LOC_CONF" | sed -E 's/.*=[[:space:]]*([0-9]+).*/\1/')
              echo "The currently set port is $N_PORT"
              echo "Please tell me the port number to change"
              read -p "Change port: " C_PORT

              sed -i "s/^port[[:space:]]*=[[:space:]]*$N_PORT/port = $C_PORT/" "$LOC_CONF"
              continue
              ;;
            2)
              echo "The number selected in the Posgresql setup task is $P_CHOISE."
              MC=$(grep -E '^[[:space:]]*max_connections[[:space:]]*=' "$LOC_CONF" | sed -E 's/.*=[[:space:]]*([0-9]+).*/\1/')
              echo "The currently set max_connections is $MC"
              echo "Please tell me the max_connections to change"
              read -p "Change max_connections: " C_MC

              sed -i -E "s|^[[:space:]]*max_connections[[:space:]]*=[[:space:]]*[0-9]+|max_connections = $C_MC|" "$LOC_CONF"
              continue
              ;;
            3)
              echo "The number selected in the Posgresql setup task is $P_CHOISE."
              continue
              ;;
            4)
              echo "The number selected in the Posgresql setup task is $P_CHOISE."
              echo "We will complete the Posgresql setup."
              echo "$(now) / Complete the Posgresql setup task" >> sc_postgresql.log
              exit
              ;;
            *)
              echo "No number was selected in the Posgresql configuration task. Please select again."
              exit
              ;;
          esac
        done

        continue
        ;;
      5)
        echo "You selected number $CHOISE."
        echo "Not Currently Supported"
        continue
        ;;
      6)
        echo "You selected number $CHOISE."
        echo "Bye, $(whoami)"
        echo "$(now) / Termination by choice" >> sc_postgresql.log
        exit
        ;;
      *)
        echo "NO selected. End of work"
        echo "Bye, $(whoami)"
        echo "$(now) / Termination due to selected number error" >> sc_postgresql.log
        exit
        ;;
    esac
done