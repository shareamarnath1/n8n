# Open n8n on your MacBook

## Use this URL (works from any browser, no port forwarding)

**Base URL:** https://excellent-gmbh-responded-exists.trycloudflare.com

| Page | Link |
|------|------|
| Home | https://excellent-gmbh-responded-exists.trycloudflare.com/ |
| RAG workflow | https://excellent-gmbh-responded-exists.trycloudflare.com/workflow/hqcWPkklqJE5xWZx |

**Login:** `dev@example.com` / `DevPass123!`

> This URL is a temporary Cloudflare tunnel tied to this cloud agent VM. If the agent or tunnel restarts, run `bash scripts/start-n8n-with-mac-access.sh` in the agent terminal and update this file with the new `*.trycloudflare.com` host.

## Alternative: Cursor port forward to `127.0.0.1:5678`

1. Open [this agent run](https://cursor.com/agents/bc-d1493161-5ea5-4d16-a0fb-201e9bd04813).
2. Click the **plug** icon (or **Ports** → Forward **5678**).
3. On your Mac: http://127.0.0.1:5678/workflow/hqcWPkklqJE5xWZx

Requires the agent tab to stay active and forwarding enabled.
