# À exécuter lors de la première installation ou après modification des fichiers .service / .timer.
#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOY_DIR="$(dirname "$SCRIPT_DIR")"

sudo cp "$DEPLOY_DIR"/*.service /etc/systemd/system/
sudo cp "$DEPLOY_DIR"/*.timer /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable sessionrunner-start.timer
sudo systemctl enable sessionrunner-stop.timer
sudo systemctl restart sessionrunner-start.timer
sudo systemctl restart sessionrunner-stop.timer

echo "Timers installed and restarted."