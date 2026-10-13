#!/bin/bash
# Railway entrypoint for Oryx: point the UI's RTMP address at Railway's TCP proxy, then
# hand over to Oryx's own bootstrap (Redis, SRS, platform; saves Redis on SIGTERM).
set -euo pipefail

addr=""
if [ -n "${RAILWAY_TCP_PROXY_DOMAIN:-}" ]; then
  addr="$RAILWAY_TCP_PROXY_DOMAIN:$RAILWAY_TCP_PROXY_PORT"
  echo "railway: stream from OBS to rtmp://$addr/live/"
fi
for f in /usr/local/oryx/ui/build/*/index.html; do
  sed -i 's|<script>window.ORYX_RTMP_ADDR=[^<]*</script>||' "$f"
  [ -z "$addr" ] || sed -i "s|<head>|<head><script>window.ORYX_RTMP_ADDR=\"$addr\"</script>|" "$f"
done

# SRS refuses to start with fewer than ~1128 open files (max_connections 1000 + its own).
ulimit -n "$(( $(ulimit -Hn) < 10000 ? $(ulimit -Hn) : 10000 ))" 2>/dev/null || true

exec ./bootstrap
