#!/bin/bash
set -e

echo "Starting Hytale Server..."

if [ "$(id -u)" = "0" ]; then
    echo "Fixing permissions..."
    chown -R hytale:hytale /hytale-server 2>/dev/null || true
    exec gosu hytale "$0" "$@"
fi

if [ ! -f "HytaleServer.jar" ] || [ ! -f "Assets.zip" ]; then
    echo "Server files missing. Downloading..."
    /scripts/update-server.sh
elif [ "$AUTO_UPDATE" = "true" ]; then
    echo "Checking for updates..."
    /scripts/update-server.sh || echo "Update failed, using existing files"
fi

[ -f "config.json" ] && /scripts/update-config.sh

JAVA_ARGS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -XX:+UseG1GC"
[ -f "HytaleServer.aot" ] && JAVA_ARGS="$JAVA_ARGS -XX:AOTCache=HytaleServer.aot"

SERVER_ARGS="--assets Assets.zip --bind ${BIND_ADDRESS:-0.0.0.0:5520}"
[ "$ENABLE_BACKUPS" = "true" ] && SERVER_ARGS="$SERVER_ARGS --backup --backup-dir ${BACKUP_DIR:-/hytale-server/backups} --backup-frequency ${BACKUP_FREQUENCY:-30}"
[ "$DISABLE_SENTRY" = "true" ] && SERVER_ARGS="$SERVER_ARGS --disable-sentry"

exec java $JAVA_ARGS -jar HytaleServer.jar $SERVER_ARGS
