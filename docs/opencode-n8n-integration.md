# OpenCode Zen + n8n

Based on [OpenCode Zen docs](https://opencode.ai/docs/zen/) and [n8n community guidance](https://community.n8n.io/t/opencode-endpoints/302468).

## What Zen is

OpenCode Zen is an API gateway (`https://opencode.ai/zen/v1`) with curated models. It is **not** the self-hosted OpenCode Server (that uses Basic Auth on port 4096 and the `n8n-nodes-opencode-ai` community package).

For Zen, use n8n’s **OpenAI-compatible** integration with a **custom base URL**.

## n8n setup (UI)

1. **Credentials** → **OpenAI API** → create **OpenCode Zen**
   - **API Key:** from [opencode.ai](https://opencode.ai) Zen billing / API keys (store only in n8n credentials, not in git)
   - **Base URL:** `https://opencode.ai/zen/v1`
2. In your workflow, add **OpenAI Chat Model** (LangChain) and connect it to the **AI Agent** *Model* input.
3. **Model** examples (see [Zen endpoints table](https://opencode.ai/docs/zen/)):
   - OpenAI-compatible: `deepseek-v4-flash-free`, `kimi-k2.5`, `gpt-5.4-mini`, … → use `/chat/completions` via OpenAI node
   - Claude models use `/messages` → use **Anthropic Chat Model** with base URL `https://opencode.ai/zen/v1` instead
4. List models: `GET https://opencode.ai/zen/v1/models` with `Authorization: Bearer <API_KEY>`.

## This VM (already configured)

- Workflow **Local chatbot with RAG** (`hqcWPkklqJE5xWZx`) uses **OpenCode Zen** chat model `deepseek-v4-flash-free` on the AI Agent (Ollama chat model removed from that agent).
- API key is in n8n credential **OpenCode Zen** (not in this repo). Optional local reference: `~/.config/n8n-opencode.env` on the agent VM (`chmod 600`).

## Quick API test (terminal)

```bash
curl -s https://opencode.ai/zen/v1/chat/completions \
  -H "Authorization: Bearer $OPENCODE_ZEN_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"deepseek-v4-flash-free","messages":[{"role":"user","content":"Hello"}]}'
```

## Mac access

Use the public tunnel URL in [`docs/MAC-ACCESS.md`](MAC-ACCESS.md) and open the same workflow in the browser chat panel.

## Security

Rotate your API key if it was ever pasted in chat or committed. Use n8n credentials + env files outside git only.
