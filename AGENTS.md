# AGENTS.md

## Repository state

This Git repository (`shareamarnath1/n8n`) currently contains only `README.md` (title: n8n). There is **no application source**, lockfiles, Docker Compose, or test scripts in-tree yet. Lint and unit tests defined in upstream n8n do not apply until the monorepo (or your own code) is added.

To work on **n8n itself**, clone or sync from [n8n-io/n8n](https://github.com/n8n-io/n8n) and follow [CONTRIBUTING.md](https://github.com/n8n-io/n8n/blob/master/CONTRIBUTING.md).

## Cursor Cloud specific instructions

### Node.js version (required for n8n)

n8n requires **Node.js >= 22.22**. The VM may expose `/exec-daemon/node` (older 22.14) **before** nvm on `PATH`. Prepend nvm’s Node when running n8n or installing the monorepo:

```bash
export PATH="/home/ubuntu/.nvm/versions/node/v22.22.2/bin:$PATH"
node --version   # should be v22.22.2 or newer
```

`corepack` + `pnpm@10.32.1` are enabled for future monorepo work (`pnpm install`, `pnpm dev`, `pnpm agent:setup` per upstream docs).

### Running n8n locally (no source in this repo)

Quick start (matches upstream README), in a tmux session:

```bash
export PATH="/home/ubuntu/.nvm/versions/node/v22.22.2/bin:$PATH"
export N8N_HOST=0.0.0.0 N8N_PORT=5678 N8N_SECURE_COOKIE=false
npx --yes n8n@latest
```

- Editor: http://127.0.0.1:5678  
- Health: http://127.0.0.1:5678/healthz  

Data is stored under `~/.n8n` by default.

### Upstream monorepo (when you add/sync source)

| Task | Command (from repo root) |
|------|---------------------------|
| Install | `pnpm install` (or `pnpm agent:setup install`) |
| Dev servers | `pnpm dev` |
| Lint | `pnpm lint` |
| Tests | `pnpm test` |
| Build | `pnpm build` |

See upstream `.devcontainer/` and `docker/images/` for container-based workflows. Docker is **not** preinstalled in this cloud image; use Node/pnpm or install Docker if you need image builds.

### Services

| Service | Required for this stub repo? | Notes |
|---------|------------------------------|--------|
| n8n (npx or `pnpm dev`) | For runtime demos only | No code in-repo to build |
| PostgreSQL | Optional | SQLite default for local n8n |
| Redis | Optional | Queue mode in production setups |
