#!/usr/bin/env bash
# Leak guard for the PUBLIC docs repo.
# Prints only file:line [label], never the matched text (CI logs are public).
# Provider, region, internal-name and path patterns are NOT in this public file:
# they live only in the untracked .leak-terms file and the LEAK_TERMS secret (one ERE per line).
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

SCAN=(docs mkdocs.yml README.md requirements.txt .github)
ALLOW=scripts/leak-allow.txt
LABELS=(); PATS=()
add() { LABELS+=("$1"); PATS+=("$2"); }

add ipv4            '\b[0-9]{1,3}(\.[0-9]{1,3}){3}\b'
add uuid            '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'
add private-key     '-----BEGIN [A-Z ]*PRIVATE KEY-----|ssh-(rsa|ed25519|ecdsa)[a-z0-9-]* AAAA|ecdsa-sha2-'
add token           'AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{20,}|xox[abp]-[A-Za-z0-9-]{10,}'
add credential      '(api[_-]?key|secret|passw(or)?d|token)[ ]*[:=][ ]*[^ ]{8,}'
add email           '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}'
add mac-address     '\b([0-9a-f]{2}:){5}[0-9a-f]{2}\b'

terms=""
if   [ -n "${LEAK_TERMS:-}" ]; then terms=$LEAK_TERMS
elif [ -f .leak-terms ];       then terms=$(cat .leak-terms)
fi
terms=$(printf '%s\n' "$terms" | grep -v -E '^[[:space:]]*(#|$)' || true)
if [ -n "$terms" ]; then
  add private-term "$(printf '%s\n' "$terms" | paste -sd'|' -)"
elif [ "${LEAK_REQUIRE_TERMS:-0}" = "1" ]; then
  echo "leak-guard: private terms list missing (secret LEAK_TERMS)"; exit 1
else
  echo "leak-guard: warning, no private terms list (.leak-terms); generic patterns only"
fi

allow=$(mktemp); trap 'rm -f "$allow"' EXIT
[ -f "$ALLOW" ] && grep -v -E '^[[:space:]]*(#|$)' "$ALLOW" > "$allow" || true

fail=0
for i in "${!PATS[@]}"; do
  hits=$(grep -rInE -i --exclude-dir=.git -e "${PATS[$i]}" "${SCAN[@]}" 2>/dev/null || true)
  [ -s "$allow" ] && [ -n "$hits" ] && hits=$(printf '%s\n' "$hits" | grep -v -F -f "$allow" || true)
  if [ -n "$hits" ]; then
    printf '%s\n' "$hits" | cut -d: -f1,2 | sed "s/\$/  [${LABELS[$i]}]/"
    fail=1
  fi
done

# Commit messages not yet on origin/main are public once pushed
if git rev-parse --verify -q origin/main >/dev/null; then
  msgs=$(git log origin/main..HEAD --format=%B 2>/dev/null || true)
  if [ -n "$msgs" ]; then
    for i in "${!PATS[@]}"; do
      if printf '%s\n' "$msgs" | grep -qE -i -e "${PATS[$i]}"; then
        echo "commit-message  [${LABELS[$i]}]"; fail=1
      fi
    done
  fi
fi

if [ "$fail" -eq 0 ]; then echo "leak-guard: OK"; else echo "leak-guard: FAILED"; fi
exit "$fail"
