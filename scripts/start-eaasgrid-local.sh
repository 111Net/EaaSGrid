#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$ROOT_DIR/logs/local"
PID_DIR="$ROOT_DIR/.runtime/pids"

mkdir -p "$LOG_DIR" "$PID_DIR"

declare -A APP_DIRS=(
  [api]="$ROOT_DIR/apps/api"
  [dashboard]="$ROOT_DIR/apps/dashboard"
  [investor]="$ROOT_DIR/apps/investor-portal"
  [showcase]="$ROOT_DIR/apps/showcase"
)

declare -A APP_PORTS=(
  [api]=4000
  [dashboard]=3000
  [investor]=3001
  [showcase]=3002
)

declare -A APP_NAMES=(
  [api]="API"
  [dashboard]="Dashboard"
  [investor]="Investor Portal"
  [showcase]="Showcase"
)

failures=0

echo "=============================================="
echo " EaaSGRID AUTOMATED LOCAL STARTUP"
echo "=============================================="
echo

stop_port() {
    local port="$1"
    local pids

    pids="$(lsof -ti :"$port" 2>/dev/null || true)"

    if [[ -n "$pids" ]]; then
        echo "Stopping existing process on port $port..."
        kill $pids 2>/dev/null || true
        sleep 2
    fi
}

start_app() {
    local key="$1"
    local dir="${APP_DIRS[$key]}"
    local port="${APP_PORTS[$key]}"
    local name="${APP_NAMES[$key]}"
    local log="$LOG_DIR/${key}.log"
    local pidfile="$PID_DIR/${key}.pid"

    echo "----------------------------------------------"
    echo "STARTING: $name"
    echo "DIRECTORY: $dir"
    echo "PORT: $port"

    if [[ ! -f "$dir/package.json" ]]; then
        echo "FAIL: package.json not found"
        failures=$((failures + 1))
        return
    fi

    stop_port "$port"

    echo "Available scripts:"
    node -e '
      const p = require(process.argv[1]);
      console.log(JSON.stringify(p.scripts || {}, null, 2));
    ' "$dir/package.json"

    echo
    echo "Installing dependencies if required..."

    (
        cd "$dir"
        npm install
    ) >> "$log" 2>&1

    echo "Building $name if a build script exists..."

    if node -e '
      const p = require(process.argv[1]);
      process.exit(p.scripts && p.scripts.build ? 0 : 1);
    ' "$dir/package.json"; then

        (
            cd "$dir"
            npm run build
        ) >> "$log" 2>&1 || {
            echo "FAIL: $name build failed"
            echo "LOG: $log"
            failures=$((failures + 1))
            return
        }
    else
        echo "INFO: No build script found"
    fi

    echo "Starting $name..."

    case "$key" in
        api)
            (
                cd "$dir"
                PORT=4000 nohup npm run start
            ) >> "$log" 2>&1 &
            ;;

        dashboard)
            (
                cd "$dir"
                PORT=3000 nohup npm run start -- -p 3000
            ) >> "$log" 2>&1 &
            ;;

        investor)
            (
                cd "$dir"
                PORT=3001 nohup npm run start -- -p 3001
            ) >> "$log" 2>&1 &
            ;;

        showcase)
            (
                cd "$dir"
                PORT=3002 nohup npm run start -- --port 3002
            ) >> "$log" 2>&1 &
            ;;
    esac

    echo $! > "$pidfile"

    sleep 8

    if ss -ltn | grep -q ":${port} "; then
        echo "PASS: $name is listening on port $port"
    else
        echo "FAIL: $name did not start on port $port"
        echo "LOG: $log"
        failures=$((failures + 1))
    fi
}

for app in api dashboard investor showcase; do
    start_app "$app"
done

echo
echo "=============================================="
echo " EaaSGRID STARTUP RESULT"
echo "=============================================="

if [[ "$failures" -eq 0 ]]; then
    echo "STARTUP_STATUS=PASS"
    exit 0
else
    echo "STARTUP_STATUS=FAIL"
    echo "FAILURES=$failures"
    echo
    echo "Logs:"
    find "$LOG_DIR" -type f -maxdepth 1 -print
    exit 1
fi
