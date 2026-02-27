#!/bin/bash
# --------------------------------------------------------------
#                   PostgreSQL BackUP
#                                       Ver. 1.0
#
#                                       Date 2026-02-27
#                                       Create by Yoo Min Sang
#                                       OS Version : Ubuntu 24.04
#                                       DBMS : Postgresql 16
# 1. 스크립트 권한 부여
# chmod +x /hbs_pg/backup/db_backup.sh
# 2. Crontab 설정
# crontab -e
# 00 02 * * * /hbs_pg/backup/db_backup.sh >> /hbs_pg/backup/backup.log 2>&1
# --------------------------------------------------------------

BACKUP_DIR="/Script/Postgresql/backUp"          # 백업 파일이 저장될 경로
LOG_FILE="${BACKUP_DIR}/backup.log"             # 로그파일 경로
RETENTION_DAYS=7                                # 보관 기간 (7일)
DATE=$(date +%Y%m%d_%H%M%S)                     # 파일명에 사용할 날짜/시간

# 백업 디렉토리가 없으면 생성
mkdir -p "$BACKUP_DIR"

# 로그파일 생성
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

echo "--------------------------------------------------------------------"
echo ${DATE}

# DB 리스트 생성
DB_LIST=$(psql -U postgres -At -c "SELECT datname FROM pg_database WHERE datistemplate = false;")

for db in $DB_LIST; do
    pg_dump -U postgres -Fc -f "${BACKUP_DIR}/${DATE}_${db}.bak" "$db"

    if [ $? -eq 0 ]; then
        echo "성공: ${DATE}_${db}.bak"
    else
        echo "실패: $db"
    fi
done

echo "--------------------------------------------------------------------"

find "$BACKUP_DIR" -type f -name "*.bak" -mtime +$RETENTION_DAYS -exec rm -f {} \; -print
