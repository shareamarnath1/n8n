#!/usr/bin/env bash
# Start n8n + Cloudflare quick tunnel so you can open n8n from a Mac (or any browser).
# Tunnel URL changes each time you restart the tunnel; see /workspace/.n8n-public-url after start.

set -euo pipefail

export PATH="/home/ubuntu/.nvm/versions/node/v22.22.2/bin:${PATH}"

N8N_PORT="${N8N_PORT:-5678}"
LOG="/tmp/cloudflared-n8n.log"
URL_FILE="/workspace/.n8n-public-url"
TMUX_CONF="${TMUX_CONF:-/exec-daemon/tmux.portal.conf}"

if ! command -v tmux >/dev/null; then
  echo "tmux is required" >&2
  exit 1
fi

if [[ ! -x /tmp/cloudflared ]]; then
  curl -fsSL -o /tmp/cloudflared \
    https://github.com/cloudflare/cloudflared/releases/download/2025.2.0/cloudflared-linux-amd64
  chmod +x /tmp/cloudflared
fi

# Tunnel first (or reuse if already running)
if ! tmux -f "$TMUX_CONF" has-session -t "=n8n-tunnel" 2>/dev/null; then
  tmux -f "$TMUX_CONF" new-session -d -s n8n-tunnel -c /workspace -- "${SHELL:-bash}" -l
  tmux -f "$TMUX_CONF" send-keys -t n8n-tunnel:0.0 \
    "rm -f '$LOG'; /tmp/cloudflared tunnel --url http://127.0.0.1:${N8N_PORT} 2>&1 | tee '$LOG'" C-m
fi

TUNNEL_URL=""
for _ in $(seq 1 30); do
  TUNNEL_URL=$(grep -oE 'https://[a-zA-Z0-9-]+\.trycloudflare\.com' "$LOG" 2>/dev/null | head -1 || true)
  [[ -n "$TUNNEL_URL" ]] && break
  sleep 1
done

if [[ -z "$TUNNEL_URL" ]]; then
  echo "Could not read tunnel URL from $LOG" >&2
  exit 1
fi

echo "$TUNNEL_URL" >"$URL_FILE"
echo "Public URL: $TUNNEL_URL"

# n8n
if ! tmux -f "$TMUX_CONF" has-session -t "=n8n-quickstart" 2>/dev/null; then
  tmux -f "$TMUX_CONF" new-session -d -s n8n-quickstart -c /workspace -- "${SHELL:-bash}" -l
fi

tmux -f "$TMUX_CONF" send-keys -t n8n-quickstart:0.0 C-c 2>/dev/null || true
sleep 1
tmux -f "$TMUX_CONF" send-keys -t n8n-quickstart:0.0 \
  "export PATH=\"/home/ubuntu/.nvm/versions/node/v22.22.2/bin:\$PATH\"" C-m
tmux -f "$TMUX_CONF" send-keys -t n8n-quickstart:0.0 \
  "export N8N_HOST=0.0.0.0 N8N_PORT=${N8N_PORT} N8N_SECURE_COOKIE=false N8N_PROTOCOL=https N8N_EDITOR_BASE_URL=${TUNNEL_URL} WEBHOOK_URL=${TUNNEL_URL}/" C-m
tmux -f "$TMUX_CONF" send-keys -t n8n-quickstart:0.0 'npx --yes n8n@latest' C-m

echo "Workflow (RAG): ${TUNNEL_URL}/workflow/hqcWPkklqJE5xWZx"
echo "Login: dev@example.com / DevPass123!"
