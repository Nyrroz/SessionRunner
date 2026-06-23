#!/bin/bash
set -e

sudo systemctl stop sessionrunner-start.timer
sudo systemctl stop sessionrunner-stop.timer

sudo systemctl disable sessionrunner-start.timer
sudo systemctl disable sessionrunner-stop.timer

echo "Timers disabled."