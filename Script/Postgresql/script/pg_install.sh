#!/bin/bash
# --------------------------------------------------------------
#                   Install Postgresql
#                                       Ver. 1.0
#
#                                       Date 2026-01-28
#                                       Create by Yoo Min Sang
#                                       OS Version : Ubuntu 24.04
#                                       DBMS : Postgresql 16
#
# 로그위치 변경 -> Postgresql.conf설정파일변경
# logging_collector = on
# log_directory = '/hbs_pg/log'
# log_filename = 'postgresql_%Y%m%d.log'
# log_rotation_age = 1d
# log_rotation_size = 0
# --------------------------------------------------------------

# Postgres 유저 생성
useradd -r -m -d /home/postgres -s /bin/bash postgres
read -sp "Set the postgres account password: " P_PW
echo ""
echo "postgres:$P_PW" | sudo chpasswd

# Postgresql 설치 디렉토리 생성
echo "Please enter the install path for Postgresql."
read I_LOC
if [[ ! -f "$I_LOC" ]]; then
  echo "The path does not exist. A path will be created automatically."
  mkdir -p $I_LOC
  chown -R postgres:postgres $I_LOC
  chmod 700 $I_LOC
fi

# Postgresql 데이터 영역 디렉토리 생성
echo "Please enter the data path for Postgresql."
read D_LOC
if [[ ! -f "$D_LOC" ]]; then
  echo "The path does not exist. A path will be created automatically."
  mkdir -p $D_LOC
  chown -R postgres:postgres $D_LOC
  chmod 700 $D_LOC
fi

# Postgresql 로그 영역 디렉토리 생성
echo "Please enter the log path for Postgresql."
read L_LOC
if [[ ! -f "$L_LOC" ]]; then
  echo "The path does not exist. A path will be created automatically."
  mkdir -p $L_LOC
  mkdir -p $L_LOC/log
  mkdir -p $L_LOC/wal
  chown -R postgres:postgres $L_LOC
  chmod 700 $L_LOC
fi

clear

# Postgresql 설치 라이브러리 설정
apt install -y build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt1-dev libssl-dev libicu-dev liblz4-dev libzstd-dev wget libicu-dev pkg-config pgtop
wget https://ftp.postgresql.org/pub/source/v16.11/postgresql-16.11.tar.gz -P $I_LOC
tar -xvf $I_LOC/postgresql-16.11.tar.gz -C $I_LOC

cd $I_LOC/postgresql-16.11
./configure --prefix=$I_LOC --with-openssl --with-icu --with-lz4 --with-zstd --enable-thread-safety --enable-debug
sleep 3
clear

# Postgresql 컴파일 설정
make| tee $I_LOC/install_log.log
sleep 3
clear

# Postgresql 컴파일 설치
make install
sleep 3
clear

# Postgresql 환경변수 설정
sudo -u postgres tee -a /home/postgres/.bash_profile > /dev/null <<EOF
export PGHOME=$I_LOC
export PATH=\$PGHOME/bin:\$PATH
export LD_LIBRARY_PATH=\$PGHOME/lib
EOF

sudo -i -u postgres bash -c "source ~/.bash_profile && psql --version"

# initdb (data초기화)
sudo -i -u postgres $I_LOC/bin/initdb -D $D_LOC -X $L_LOC/wal
sleep 1
clear

# Posgresql 설정파일(postgresql.conf) 위치설정
LOC_CONF="${D_LOC}/postgresql.conf"
sleep 1

# Posgresql 설정파일(postgresql.conf) 포트변경
N_PORT=$(grep -E '^[[:space:]]*#?[[:space:]]*port[[:space:]]*=' $LOC_CONF | sed -E 's/.*=[[:space:]]*([0-9]+).*/\1/')
echo "The currently set port is $N_PORT"
read -p "Change port: " C_PORT

sed -i -E "s/^[[:space:]]*#?[[:space:]]*port[[:space:]]*=[[:space:]]*[0-9]+/port = $C_PORT/" $LOC_CONF

echo "$(whoami) / $(now) : Port change from $N_PORT -> $C_PORT has been completed." >> $L_NAME
sleep 1
clear

# Posgresql 설정파일(postgresql.conf) Max_Connection 변경
MC=$(grep -E '^[[:space:]]*max_connections[[:space:]]*=' "$LOC_CONF" | sed -E 's/.*=[[:space:]]*([0-9]+).*/\1/')
echo "The currently set max_connections is $MC"
read -p "Change max_connections: " C_MC

sed -i -E "s|^[[:space:]]*max_connections[[:space:]]*=[[:space:]]*[0-9]+|max_connections = $C_MC|" "$LOC_CONF"

echo "$(whoami) / $(now) : Max Connections change from $MC -> $C_MC has been completed." >> $L_NAME
sleep 1
clear

# Posgresql 설정파일(postgresql.conf) Shared Buffers 변경
N_MEM=$(free -h | awk '/^Mem:/ {sub(/i/, "", $2); print $2}')
N_BUF=$(grep -E '^[[:space:]]*shared_buffers[[:space:]]*=' "$LOC_CONF" | sed -E 's/.*=[[:space:]]*([0-9]+).*/\1/')
echo "Current total memory capacity : $N_MEM"
echo "Current buffer settings : $N_BUF"
read -p "Change shared_buffers: " C_BUF

sed -i -E "s|^[[:space:]]*shared_buffers[[:space:]]*=[[:space:]]*[0-9]+|shared_buffers = $C_BUF|" "$LOC_CONF"

echo "$(whoami) / $(now) : Shared Buffers change from $N_BUF -> $C_BUF has been completed." >> $L_NAME
sleep 3
clear

# Posgresql 설정파일(postgresql.conf) 로그파일 기록설정
sed -i "s/^#logging_collector = off/logging_collector = on/" $LOC_CONF
sed -i "s|^#log_directory = 'log'|log_directory = '$L_LOC/log'|" $LOC_CONF
sed -i "s/^#log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'/log_filename = 'postgresql_%Y%m%d.log'/" $LOC_CONF
sed -i "s/^#log_rotation_age = 1d/log_rotation_age = 1d/" $LOC_CONF
sed -i "s/^#log_rotation_size = 10MB/log_rotation_size = 0/" $LOC_CONF

# Postgresql 기동
sudo -i -u postgres pg_ctl -D $D_LOC -l $L_LOC/log/pg_on_off.log start
sudo -i -u postgres pg_ctl -D $D_LOC -l $L_LOC/log/pg_on_off.log stop

# systemd 서비스 등록
bash -c "cat << 'EOF' > /etc/systemd/system/postgresql.service
[Unit]
Description=PostgreSQL 16 (Source Build)
After=network.target

[Service]
Type=forking
User=postgres
ExecStart=$I_LOC/bin/pg_ctl -D $D_LOC -l $L_LOC/log/pg_on_off.log start
ExecStop=$I_LOC/bin/pg_ctl -D $D_LOC -l $L_LOC/log/pg_on_off.log stop
ExecReload=$I_LOC/bin/pg_ctl -D $D_LOC -l $L_LOC/log/pg_on_off.log reload
TimeoutSec=300

[Install]
WantedBy=multi-user.target
EOF"

systemctl daemon-reload

# Postgresql 기동
systemctl start postgresql

# history 삭제
history -c