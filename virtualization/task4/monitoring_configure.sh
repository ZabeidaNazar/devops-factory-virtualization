#!/bin/bash

sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus

curl -L \
    -o prometheus.tar.gz \
    https://github.com/prometheus/prometheus/releases/download/v3.5.4/prometheus-3.5.4.linux-amd64.tar.gz

mkdir prometheus
tar -xf prometheus.tar.gz --strip-components=1 -C prometheus

sudo cp prometheus/prometheus /usr/bin/prometheus
sudo cp prometheus/promtool /usr/bin/promtool

sudo mkdir /etc/prometheus

sudo touch \
    /etc/prometheus/prometheus.yml \
    /etc/prometheus/rules.yml \
    /etc/prometheus/web.yml

sudo chmod 0750 /etc/prometheus
sudo chmod 0600 /etc/prometheus/prometheus.yml
sudo chmod 0600 /etc/prometheus/rules.yml
sudo chmod 0600 /etc/prometheus/web.yml
sudo chown -R prometheus:prometheus /etc/prometheus

sudo mkdir /var/lib/prometheus
sudo mkdir /var/lib/prometheus/tsdb

sudo mv prometheus/console_libraries /var/lib/prometheus
sudo mv prometheus/consoles /var/lib/prometheus

sudo chmod 0750 /var/lib/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus

sudo tee /etc/prometheus/prometheus.yml <<'EOF'
scrape_configs:
- job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'web_server'
    static_configs:
      - targets: ['192.168.50.10:9100']
  - job_name: 'db_server'
    static_configs:
      - targets: ['192.168.50.20:9104']
rule_files: [/etc/prometheus/rules.yml]
EOF

sudo tee /etc/prometheus/rules.yml <<'EOF'
groups:
- name: configuration-rollups
  interval: 1m
  rules:
  - record: bindplane_agent_measurements:rollup:rate:1m
    expr: sum without (agent) (rate(bindplane_agent_measurements{}[1m9s999ms] offset 10s))
- name: 5m-configuration-rollups
  interval: 5m
  rules:
  - record: bindplane_agent_measurements:rollup:rate:5m
    expr: sum without (agent) (rate(bindplane_agent_measurements:1m{}[5m59s999ms] offset 10s))
- name: 1h-configuration-rollups
  interval: 1h
  rules:
  - record: bindplane_agent_measurements:rollup:rate:1h
    expr: sum without (agent) (rate(bindplane_agent_measurements:15m{}[1h14m59s999ms] offset 10s))
EOF

sudo touch /usr/lib/systemd/system/prometheus.service
sudo chmod 0640 /usr/lib/systemd/system/prometheus.service

sudo tee /etc/systemd/system/prometheus.service <<'EOF'
[Unit]
Description=Prometheus
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target
[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/bin/prometheus \
--config.file /etc/prometheus/prometheus.yml \
--web.config.file /etc/prometheus/web.yml \
--storage.tsdb.retention.time 2d \
--web.enable-remote-write-receiver \
--web.listen-address :9090 \
--storage.tsdb.path /var/lib/prometheus/tsdb \
--web.console.templates=/var/lib/prometheus/consoles \
--web.console.libraries=/var/lib/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus