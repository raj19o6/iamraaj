#!/bin/sh
# Fast pre-deploy checks with no dependencies beyond a POSIX shell:
#   - every page is complete (has </html>) and has a <title>
#   - every local href/src ("/..." or relative) points at a file in public/
#   - every in-page anchor (#id) on index.html exists
# Usage: scripts/check.sh   (run from anywhere; exits non-zero on the first kind of failure)
set -eu
cd "$(dirname "$0")/../public"
fail=0
err() { echo "check: $*" >&2; fail=1; }

for page in *.html; do
  grep -q '</html>' "$page" || err "$page has no closing </html>"
  grep -q '<title>' "$page" || err "$page has no <title>"
  # Local references: absolute paths and relative files, ignoring external URLs, anchors and data URIs.
  grep -oE '(href|src)="[^"#]+"' "$page" | sed -E 's/^(href|src)="//; s/"$//' | while read -r ref; do
    case "$ref" in http://*|https://*|mailto:*|data:*|//*) continue ;; esac
    path=${ref#/}
    [ -z "$path" ] && path=index.html
    [ -e "$path" ] || { echo "check: $page links to missing $ref" >&2; echo x >> "${TMPDIR:-/tmp}/iamraaj-check.$$"; }
  done
done

for id in $(grep -oE 'href="#[^"]+"' index.html | sed -E 's/href="#//; s/"$//' | sort -u); do
  grep -q "id=\"$id\"" index.html || err "index.html links to missing anchor #$id"
done

if [ -e "${TMPDIR:-/tmp}/iamraaj-check.$$" ]; then rm -f "${TMPDIR:-/tmp}/iamraaj-check.$$"; fail=1; fi
[ "$fail" -eq 0 ] && echo "check: ok"
exit "$fail"
