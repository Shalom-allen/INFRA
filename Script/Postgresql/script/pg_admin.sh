#!/bin/bash
# --------------------------------------------------------------
#                   PostgreSQL Management
#                                       Ver. 1.0
#
#                                       Date 2026-01-28
#                                       Create by Yoo Min Sang
#                                       OS Version : Ubuntu 24.04
#                                       DBMS : Postgresql 16
# --------------------------------------------------------------
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
    STATE=$(systemctl show postgresql -p ActiveState --value)
    echo $STATE
    echo "$(whoami) / $(now) : Shutdown Posgresql" >> $L_NAME
    sleep 3
    ;;
  2)
    # Posgresql 시작
    echo "You selected number $W_CHOICE."
    echo "Start Posgresql"
    systemctl start postgresql
    STATE=$(systemctl show postgresql -p ActiveState --value)
    echo $STATE    echo "$(whoami) / $(now) : Start Posgresql" >> $L_NAME
    sleep 3
    ;;
  3)
    # Posgresql 재시작
    echo "You selected number $W_CHOICE."
    echo "Start Posgresql"
    systemctl restart postgresql
    STATE=$(systemctl show postgresql -p ActiveState --value)
    echo $STATE
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

# history 삭제
history -c