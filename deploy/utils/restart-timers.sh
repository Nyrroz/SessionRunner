# À exécuter lors de la modification seule des horaires dans les fichiers timer.
#!/bin/bash
set -e

sudo systemctl daemon-reload

sudo systemctl restart sessionrunner-start.timer
sudo systemctl restart sessionrunner-stop.timer

echo "Timers restarted."