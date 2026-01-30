#!/bin/bash
# --------------------------------------------------------------
#                   Docker
#                                       Ver. 1.0
#
#                                       Date 2026-01-30
#                                       Create by Yoo Min Sang
#                                       OS Version : Ubuntu 24.04
#                                       Docker Version : 29.2.0
# 특이사항
# 리눅스 기반에서 수행 시 아래 명령어 수행(Unix 파일 변환)
# apt install -y dos2unix
# chmod +x dk_main.sh
# dos2unix dk_main.sh
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
        
L_DIR="/media/sf_shell/Docker/Script_Log"
L_DATE=$(date '+%Y%m%d%H%M%S')
L_USER=$(whoami)
L_NAME="${L_DIR}/${L_DATE}_${L_USER}.log"

# 스크립트 시작로그
echo "Start Docker Script" >> $L_NAME
echo "$(whoami) / $(now)" >> $L_NAME
clear

# 작업 선택
while true; do
    clear
    echo "--------------------------------------------------------------------------------------"
    echo "Welcome to the Docker Script"
    echo "Please select the task you want to perform."
    echo 
    echo "1) Docker Engine Install"
    echo "2) Check Docker Status"
    echo "3) Running a Docker Container"
    echo "4) End of work"
    echo "--------------------------------------------------------------------------------------"
    read -p "Select [1-4]: " CHOICE
    clear

    case "$CHOICE" in
      1) 
        # 패키지 업데이트 & Docker 설치
        echo "You selected number $CHOICE."
        apt-get update -y
        apt-get install ca-certificates curl gnupg -y

        install -m 0755 -d /etc/apt/keyrings

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

        chmod a+r /etc/apt/keyrings/docker.gpg

        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        apt-get update -y

        apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

        echo "$(whoami) / $(now) : Task $CHOICE completed" >> $L_NAME
        echo "Update and Download Is Complete"
        ;;
      2)
        # Docker 상태확인
        echo "You selected number $CHOICE."
        STATE=$(systemctl show docker -p ActiveState --value)
        TS=$(systemctl show docker -p ActiveEnterTimestamp --value)
        echo "$(whoami) / $(now) : Docker status : ${STATE} ( ${TS} )" >> $L_NAME
        echo "$(whoami) / $(now) : Task $CHOICE completed" >> $L_NAME
        echo "Docker status : ${STATE} ( ${TS} )"
        sleep 3
        ;;
      3)
        # Docker 컨테이너 생성
        echo "You selected number $CHOICE."

        while true; do
          clear
          echo "--------------------------------------------------------------------------------------"
          echo "Please select the container to install in Docker."
          echo 
          echo "1) Installing a Monitoring (Grafana & Prometheus) Container"
          echo "2) End of work"
          echo "--------------------------------------------------------------------------------------"
          read -p "Select [1-2]: " P_CHOICE
          clear

          case "$P_CHOICE" in
            1)
                echo "The number selected in the Docker monitoring tool installation task is $P_CHOICE."
                echo "Starting the installation of the Docker monitoring tool."
                echo "$(whoami) / $(now) : Starting the installation of the Docker monitoring tool." >> $L_NAME

                source $H_LOC/Monitoring/moni_main.sh

                echo "Docker monitoring tool installation is complete."
                echo "$(whoami) / $(now) : Docker monitoring tool installation is complete." >> $L_NAME

                sleep 3
                ;;
            2)
                echo "The number selected in the Docker monitoring tool installation task is $P_CHOICE."
                echo "All container installation tasks are complete."
                echo "$(whoami) / $(now) : All container installation tasks are complete." >> $L_NAME
       
                sleep 3
                break
                ;;
            *)
                echo "No number was selected during the Docker container installation process."
                echo "Please select it again."
                sleep 3
                ;;
          esac
        done
        
        echo "Docker status : ${STATE} ( ${TS} )"
        sleep 3
        ;;
      4)
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