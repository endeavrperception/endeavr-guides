#!/usr/bin/env bash
# Guard for a PUBLIC repository: fail if anything that must stay private shows up
# in the published content. Patterns are generic on purpose so that this script
# itself never reveals an internal name. Run locally with `make content-guard`.
set -euo pipefail
cd "$(dirname "$0")/.."

status=0
check() {
  local pattern=$1 what=$2 hits
  if hits=$(grep -rnE --include='*.html' --include='*.md' --include='*.js' --include='*.css' \
      --exclude-dir=.git --exclude-dir=scripts --exclude-dir=node_modules -e "$pattern" .); then
    echo "::error::Found $what"
    echo "$hits"
    status=1
  fi
}

check '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b'                                   "an IPv4 address literal"
check 'BEGIN [A-Z ]*PRIVATE KEY'                                            "a private key block"
check '\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\b' "a UUID (setup key / invitation id)"
check '\bnbp_[A-Za-z0-9]{8,}'                                               "a NetBird personal access token"
check '--setup-key[= ]+[A-Za-z0-9][A-Za-z0-9-]{7,}'                      "a setup key value"
check '[A-Za-z0-9.-]+\.(duckdns\.org|ddns\.net|no-ip\.(com|org|biz)|dyndns\.org)' "a dynamic-DNS server address"

if [ "$status" -eq 0 ]; then
  echo "content-guard: OK"
fi
exit "$status"
