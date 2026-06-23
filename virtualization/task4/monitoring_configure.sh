#!/bin/bash
set -e

# Створення користувача і груп якщо їх ще немає
if ! id -u prometheus > /dev/null 2>&1; then
  sudo groupadd --system prometheus
  sudo useradd --no-create-home -s /sbin/nologin --system -g prometheus prometheus
fi

# Отримання останньої версії
PROM_VER=$(curl -sL https://api.github.com/repos/prometheus/prometheus/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

# Завантаження prometheus
cd /tmp
curl -L \
    -o prometheus.tar.gz \
    https://github.com/prometheus/prometheus/releases/download/v${PROM_VER}/prometheus-${PROM_VER}.linux-amd64.tar.gz

# Розпакування архіву у папку
mkdir -p prometheus
tar -xf prometheus.tar.gz --strip-components=1 -C prometheus

# Копіювання бінарних файлів
sudo cp prometheus/prometheus /usr/bin/prometheus
sudo cp prometheus/promtool /usr/bin/promtool

# Конфігурації
sudo mkdir -p /etc/prometheus

# Копіювання конфігурацій
sudo cp /vagrant/prometheus/prometheus.yml /etc/prometheus/prometheus.yml
sudo cp /vagrant/prometheus/rules.yml /etc/prometheus/rules.yml
sudo cp /vagrant/prometheus/prometheus.service /etc/systemd/system/prometheus.service

sudo touch /etc/prometheus/web.yml

# Права доступу
sudo chmod 0640 /etc/systemd/system/prometheus.service
sudo chmod 0750 /etc/prometheus
sudo chmod 0600 /etc/prometheus/prometheus.yml
sudo chmod 0600 /etc/prometheus/rules.yml
sudo chmod 0600 /etc/prometheus/web.yml
# Права власності
sudo chown -R prometheus:prometheus /etc/prometheus

sudo mkdir -p /var/lib/prometheus
sudo mkdir -p /var/lib/prometheus/tsdb

# Права доступу
sudo chmod 0750 /var/lib/prometheus
# Права власності
sudo chown -R prometheus:prometheus /var/lib/prometheus

# Видалення архіву і його розпакованої версії
rm -rf /tmp/prometheus.tar.gz /tmp/prometheus

# Запуск prometheus
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl restart prometheus
sudo systemctl is-active prometheus
