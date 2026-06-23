SessionRunner is a scheduled browser-automation service: it logs into a web platform via Playwright, holds the session open for a fixed daily window, then shuts down cleanly — no in-app scheduling logic, that's delegated entirely to systemd timers on the host, which start and stop a Docker container on a daily cron-like schedule. The focus is the full deployment path rather than just the automation script: containerized runtime, host-level scheduling decoupled from the app (mirroring how a Kubernetes CronJob would split the same concern), graceful shutdown handling via SIGTERM, and a small set of idempotent Bash scripts for first-time install and ongoing updates.
Stack: Python + Playwright (automation), Docker (containerization), systemd timers (scheduling), Bash (deployment tooling), running on a Debian/Ubuntu VPS.

# Deployment

Assumes a Debian/Ubuntu host with Docker installed, and that you can `git clone` this repo onto it.

## First-time setup

```bash
git clone https://github.com/Nyrroz/SessionRunner.git
cd SessionRunner
./deploy/utils/init.sh
```

`init.sh` does four things, in order: fixes script permissions, walks you through creating `/opt/sessionrunner/.env` if it doesn't exist yet (it pauses so you can fill in real credentials before continuing), builds the Docker image, then installs and enables the two systemd timers that start and stop the container daily.

The actual schedule is hardcoded in `deploy/sessionrunner-start.timer` and `deploy/sessionrunner-stop.timer` (the `OnCalendar=` line). Edit those *before* running `init.sh` if the default window isn't what you want.

## Updating after code change

```bash
./deploy/utils/update.sh
```

Pulls latest code, re-applies script permissions, rebuilds the image, stops the currently running container if there is one, and restarts the timers so they pick up any service/timer file changes.

## Day-to-day operations

| Script | What it does |
|---|---|
| `deploy/utils/show-status.sh` | One-shot overview: is the container running, are the timers active |
| `deploy/utils/container/build.sh` | Rebuilds the image from the current code |
| `deploy/utils/container/start.sh` | Manually starts the container outside the timer schedule — useful for testing |
| `deploy/utils/container/stop.sh` | Graceful stop: sends SIGTERM, waits 15s |
| `deploy/utils/container/force-stop.sh` | Hard kill (SIGKILL) — only if `stop.sh` doesn't respond |
| `deploy/utils/container/logs.sh` | Tails the container logs |
| `deploy/utils/container/status.sh` | Container-only status, no timer info |
| `deploy/utils/timers/install-timers.sh` | (Re)installs the `.service`/`.timer` files into systemd |
| `deploy/utils/timers/restart-timers.sh` | Restarts the timers after editing the schedule |
| `deploy/utils/timers/disable-timers.sh` | Stops and disables both timers |
| `deploy/utils/timers/show-timers.sh` | Shows timer status and next scheduled run |
| `deploy/utils/timers/fix-timezone.sh` | Sets the host timezone to Europe/Paris and restarts the timers — `OnCalendar` is timezone-sensitive, so this matters |
| `deploy/utils/setup.sh` | Re-applies `+x` on every script. Runs automatically inside `init.sh` and `update.sh`; rarely needed by hand |

## A couple of things that bit me during setup

- **Git on Windows doesn't track the executable bit the way Git on macOS/Linux does.** If a script comes back with `Permission denied` on a freshly cloned host even right after `chmod +x`, it was probably last committed from a Windows machine. Fix it with `git update-index --chmod=+x <file>` instead of relying on a plain `chmod` + commit.
- `.env` is never committed (see `.gitignore`) and doesn't live inside the cloned repo at all — it sits outside it, at `/opt/sessionrunner/.env`. `init.sh` sets that up for you on first run.
