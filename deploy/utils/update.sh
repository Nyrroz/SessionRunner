#!/bin/bash
set -euo pipefail

# Resolve repository root (script is in deploy/utils)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Run git and docker build from repository root so script works from anywhere
cd "$REPO_ROOT"
git pull

docker build -t sessionrunner:latest "$REPO_ROOT"

docker stop sessionrunner 2>/dev/null || true
docker rm sessionrunner 2>/dev/null || true

sudo systemctl daemon-reload
sudo systemctl restart sessionrunner-start.timer
sudo systemctl restart sessionrunner-stop.timer || true

echo "Update completed."