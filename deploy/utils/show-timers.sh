#!/bin/bash

systemctl list-timers | grep sessionrunner

echo
echo "Start timer:"
systemctl status sessionrunner-start.timer --no-pager

echo
echo "Stop timer:"
systemctl status sessionrunner-stop.timer --no-pager