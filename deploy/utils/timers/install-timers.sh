#!/bin/bash
# À exécuter lors de la première installation ou après modification des fichiers .service / .timer.
set -euo pipefail

# Resolve directories so the script can be run from any working directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOY_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Copy service and timer files if they exist
shopt -s nullglob
service_files=("$DEPLOY_DIR"/*.service)
timer_files=("$DEPLOY_DIR"/*.timer)
if [ ${#service_files[@]} -gt 0 ]; then
	sudo cp "${service_files[@]}" /etc/systemd/system/
fi
if [ ${#timer_files[@]} -gt 0 ]; then
	sudo cp "${timer_files[@]}" /etc/systemd/system/
fi
shopt -u nullglob

sudo systemctl daemon-reload
sudo systemctl enable sessionrunner-start.timer
sudo systemctl enable sessionrunner-stop.timer
sudo systemctl restart sessionrunner-start.timer
sudo systemctl restart sessionrunner-stop.timer

echo "Timers installed and restarted."