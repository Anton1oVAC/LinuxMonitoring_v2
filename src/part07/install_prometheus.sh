#!/bin/bash

# Change the IP address of node_exporter in the yaml file
# If necessary, change the version of Prometheus

mkdir prom
cd prom
wget https://github.com/prometheus/prometheus/releases/download/v2.54.1/prometheus-2.54.1.linux-arm64.tar.gz
tar xvfz prometheus-2.54.1.linux-arm64.tar.gz
cd prometheus-2.54.1.linux-arm64

mv prometheus /usr/bin/
rm -rf  prom

mkdir -p /etc/prometheus
mkdir -p /etc/prometheus/data

useradd -rs /bin/false prometheus
chown prometheus:prometheus /usr/bin/prometheus
chown -R prometheus:prometheus /etc/prometheus

cat <<EOF> /etc/prometheus/prometheus.yml
global:
  scrape_interval: 5s

scrape_configs:
  - job_name      : "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
  - job_name: "node_exporter"
    static_configs:
      - targets:
          - 192.168.64.31:9100
EOF

chown prometheus:prometheus /etc/prometheus/prometheus.yml


cat <<EOF> /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Server
After=network.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
ExecStart=/usr/bin/prometheus \
        --config.file /etc/prometheus/prometheus.yml \
        --storage.tsdb.path /etc/prometheus/data

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus
prometheus --version
