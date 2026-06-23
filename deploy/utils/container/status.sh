#!/bin/bash
# Affiche si le container sessionrunner tourne actuellement.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if docker ps --filter "name=^/sessionrunner$" --format '{{.Names}}' | grep -q '^sessionrunner$'; then
    echo "sessionrunner is RUNNING"
    docker ps --filter "name=sessionrunner" --format 'table {{.Names}}\t{{.Status}}\t{{.RunningFor}}'
else
    echo "sessionrunner is NOT running"
fi