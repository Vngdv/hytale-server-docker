#!/bin/bash
set -e

[ ! -f "config.json" ] && echo "config.json not found, skipping" && exit 0

echo "Updating configuration from environment variables..."

JQ_FILTER="."
[ -n "$SERVER_NAME" ] && JQ_FILTER="$JQ_FILTER | .ServerName = \"$SERVER_NAME\""
[ -n "$MOTD" ] && JQ_FILTER="$JQ_FILTER | .MOTD = \"$MOTD\""
[ -n "$PASSWORD" ] && JQ_FILTER="$JQ_FILTER | .Password = \"$PASSWORD\""
[ -n "$MAX_PLAYERS" ] && JQ_FILTER="$JQ_FILTER | .MaxPlayers = $MAX_PLAYERS"
[ -n "$MAX_VIEW_RADIUS" ] && JQ_FILTER="$JQ_FILTER | .MaxViewRadius = $MAX_VIEW_RADIUS"
[ -n "$DEFAULT_WORLD" ] && JQ_FILTER="$JQ_FILTER | .Defaults.World = \"$DEFAULT_WORLD\""
[ -n "$DEFAULT_GAMEMODE" ] && JQ_FILTER="$JQ_FILTER | .Defaults.GameMode = \"$DEFAULT_GAMEMODE\""

jq "$JQ_FILTER" config.json > /tmp/config.json.tmp && mv /tmp/config.json.tmp config.json

echo "Configuration updated successfully"
