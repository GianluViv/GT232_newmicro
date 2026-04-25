#!/bin/bash
set -e

cd "$(dirname "$0")"

git add -A

if git diff --cached --quiet; then
    echo "Nessuna modifica da committare."
    exit 0
fi

echo "Modifiche rilevate:"
git diff --cached --stat

read -rp "Messaggio di commit: " msg
if [ -z "$msg" ]; then
    msg="Update $(date '+%Y-%m-%d %H:%M')"
fi

git commit -m "$msg"
git push
echo "Push completato."
