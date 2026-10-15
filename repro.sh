#!/usr/bin/env bash
# Cold-starts `astro dev` and requests two pages in order. Usage: ./repro.sh [/first] [/second]
# Default order (/ then /b) triggers the bug on astro >= 7.3.6.
set -u
PORT=${PORT:-4020}; FIRST=${1:-/}; SECOND=${2:-/b}
cd "$(dirname "$0")"
npx astro dev stop >/dev/null 2>&1
rm -rf .astro node_modules/.vite
npx astro dev --background --host 127.0.0.1 --port "$PORT" >/dev/null 2>&1 </dev/null
for _ in $(seq 1 200); do curl -s -o /dev/null -m 1 "http://127.0.0.1:$PORT/favicon.ico" && break; sleep 0.1; done
echo "astro $(node -p "require('astro/package.json').version"), vite $(node -p "require('vite/package.json').version")"
for p in "$FIRST" "$SECOND"; do
  echo "GET $p -> $(curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:$PORT$p")"
done
npx astro dev logs 2>/dev/null | grep -ao 'Could not find server component name[^\\"]*' | head -1
npx astro dev stop >/dev/null 2>&1
