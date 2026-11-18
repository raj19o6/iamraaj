#!/bin/sh
# One command for the live demos. Each app keeps its own deploy script (deploy/iamraaj/deploy.sh
# in its repo); this runs them and checks the sites.
#   deploy/demos.sh status                  are the portfolio and all demos up?
#   deploy/demos.sh billing|hr|kavach       deploy one demo
#   deploy/demos.sh all                     deploy all three, then check them
#   HOST=other deploy/demos.sh all          another SSH host (default: bstock)
# Outreach and Stock have no public demo, on purpose (Stock never will).
set -eu
ROOT=$(cd "$(dirname "$0")/../.." && pwd)    # ~/Documents/raaj
HOST=${HOST:-bstock}
APPS="billing hr kavach"

url() { case $1 in billing) echo https://billing.iamraaj.in/api/health ;;
                   hr)      echo https://hr.iamraaj.in/api/health ;;
                   kavach)  echo https://kavach.iamraaj.in/health ;; esac; }

status() {
  bad=0
  for u in https://iamraaj.in/ $(for a in $APPS; do url $a; done) https://hr.iamraaj.in/ https://kavach.iamraaj.in/; do
    code=$(curl -s -o /dev/null -m 15 -w '%{http_code}' "$u" || true)
    printf '%-42s %s\n' "$u" "$code"
    [ "$code" = 200 ] || bad=1
  done
  [ $bad = 0 ] && echo "All up." || { echo "Something is down (see above)." >&2; return 1; }
}

deploy() {
  repo=$ROOT/iamraaj-$1
  [ -x "$repo/deploy/iamraaj/deploy.sh" ] || { echo "No deploy script in $repo" >&2; exit 1; }
  if [ -n "$(git -C "$repo" status --porcelain)" ]; then
    echo "Note: $1 has uncommitted changes; they will be deployed too." >&2
  fi
  echo "### $1 ($(git -C "$repo" log -1 --format='%h %s'))"
  "$repo/deploy/iamraaj/deploy.sh" "$HOST"
}

preflight() {
  day=$(TZ=Asia/Kolkata date +%u); hour=$(TZ=Asia/Kolkata date +%H)
  if [ "$day" -le 5 ] && [ "$hour" -ge 8 ] && [ "$hour" -le 16 ]; then
    echo "Stopping: Indian market hours (Mon-Fri 08:00-16:59 IST). Run after 17:00 IST or on a weekend." >&2; exit 1
  fi
  docker info >/dev/null 2>&1 || { echo "Docker is not running on this Mac (images are built here). Start Docker Desktop." >&2; exit 1; }
}

case ${1:-} in
  status) status ;;
  billing|hr|kavach) preflight; deploy "$1"; status ;;
  all) preflight; for a in $APPS; do deploy "$a"; done; status ;;
  *) sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit 2 ;;
esac
