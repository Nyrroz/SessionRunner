#!/bin/bash
set -e

TIMEZONE="Europe/Paris"

echo "Setting timezone to $TIMEZONE..."

sudo timedatectl set-timezone "$TIMEZONE"

echo
timedatectl

echo
echo "Reloading systemd timers..."

sudo systemctl daemon-reload

sudo systemctl restart sessionrunner-start.timer
sudo systemctl restart sessionrunner-stop.timer

echo
echo "Current SessionRunner timers:"
systemctl list-timers | grep sessionrunner || true