#!/bin/bash
# Build l'image Docker sessionrunner:latest depuis la racine du repo.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

cd "$REPO_ROOT"
docker build -t sessionrunner:latest .

echo "Image sessionrunner:latest built."