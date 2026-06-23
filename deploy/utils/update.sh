#!/bin/bash
set -e

git pull

docker build -t sessionrunner:latest .

docker stop sessionrunner 2>/dev/null || true
docker rm sessionrunner 2>/dev/null || true

sudo systemctl daemon-reload
sudo systemctl restart sessionrunner-start.timer
sudo systemctl restart sessionrunner-stop.timer

echo "Update completed."