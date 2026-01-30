#!/bin/bash
# --------------------------------------------------------------
#                   Docker
#                                       Ver. 1.0
#
#                                       Date 2026-01-30
#                                       Create by Yoo Min Sang
#                                       OS Version : Ubuntu 24.04
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
echo "Start package installation" >> $L_NAME
echo "$(whoami) / $(now)" >> $L_NAME
clear

