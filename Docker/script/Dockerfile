# Install Ubuntu 22.04
FROM ubuntu:24.04

# Install Package
RUN apt-get update -y && apt-get install vim net-tools systemd nginx -y

# Create Directory
RUN mkdir /etc/prometheus
RUN mkdir /etc/download
RUN mkdir /var/lib/prometheus

# Create User
RUN useradd --no-create-home --shell /bin/false prome
RUN useradd --no-create-home --shell /bin/false node_exporter

# Install Prometheus File
WORKDIR /etc/download
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.37.9/prometheus-2.37.9.linux-amd64.tar.gz
RUN tar -xvzf prometheus-2.37.9.linux-amd64.tar.gz -C /etc/download

# File Move and Grant prome
RUN cp prometheus-2.37.9.linux-amd64/prometheus /usr/local/bin/
RUN cp prometheus-2.37.9.linux-amd64/promtool /usr/local/bin/
RUN chown prome:prome /usr/local/bin/prometheus
RUN chown prome:prome /usr/local/bin/promtool
RUN cp -r prometheus-2.37.9.linux-amd64/consoles /etc/prometheus
RUN cp -r prometheus-2.37.9.linux-amd64/console_libraries /etc/prometheus
RUN chown -R prome:prome /etc/prometheus/consoles
RUN chown -R prome:prome /etc/prometheus/console_libraries

# ENTRYPOINT ./etc/download/prometheus-2.37.9.linux-amd64/prometheus
