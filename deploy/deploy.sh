#!/bin/sh
# Publishes public/ to https://iamraaj.in and installs the shared Caddy files. Safe to run again.
#   deploy/deploy.sh [ssh-host]      (default host: bstock)
#
# The VPS's Caddy belongs to the bBilling project (/opt/bbilling). Its Caddyfile needs one line,
#   import /data/iamraaj/caddy/*.caddy
# after which every *.iamraaj.in site lives in its own file under that folder in Caddy's data volume.
# This script adds that line if it is missing; keep it in bbilling's deploy/Caddyfile too, or a
# bBilling redeploy will drop every iamraaj.in site.
set -eu
cd "$(dirname "$0")/.."
HOST=${1:-bstock}
ROOT=/var/lib/docker/volumes/bbilling_caddy_data/_data/iamraaj
CADDYFILE=/opt/bbilling/deploy/Caddyfile
IMPORT='import /data/iamraaj/caddy/*.caddy'
ssh_() { ssh -o ClearAllForwardings=yes -o BatchMode=yes -o ConnectTimeout=20 "$HOST" "$@"; }

scripts/check.sh
for f in public/index.html public/404.html; do
  grep -q '</html>' "$f" || { echo "$f looks truncated" >&2; exit 1; }
done

echo "== site files"
ssh_ "mkdir -p $ROOT/www $ROOT/caddy"
rsync -rlt --delete -e "ssh -o ClearAllForwardings=yes -o BatchMode=yes" public/ "$HOST:$ROOT/www/"

ssh_ "find $ROOT -type d -exec chmod 755 {} + && find $ROOT -type f -exec chmod 644 {} +"
echo "== Caddy"
rsync -rlt -e "ssh -o ClearAllForwardings=yes -o BatchMode=yes" deploy/caddy/ "$HOST:$ROOT/caddy/"
# Append in place (not sed -i): the Caddyfile is bind-mounted as a single file, so its inode must not change.
ssh_ "grep -qxF '$IMPORT' $CADDYFILE || { cp -p $CADDYFILE $CADDYFILE.bak-\$(date +%Y%m%d%H%M%S); printf '\n# Every *.iamraaj.in site (managed from the iamraaj repo).\n%s\n' '$IMPORT' >> $CADDYFILE; echo 'import line added'; }"
ssh_ 'docker exec bbilling-caddy-1 caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile >/dev/null && docker exec bbilling-caddy-1 caddy reload --config /etc/caddy/Caddyfile --adapter caddyfile && echo "Caddy reloaded"'

echo "== check"
code=$(curl -s -o /dev/null -w '%{http_code}' https://iamraaj.in/)
[ "$code" = 200 ] && echo "https://iamraaj.in is up" || { echo "https://iamraaj.in returned $code" >&2; exit 1; }
