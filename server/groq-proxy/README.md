# Groq chat proxy

A tiny Cloudflare Worker that sits between the Mera Tun app and Groq's
API. The app never holds a Groq API key — only this worker does, as a
Cloudflare secret — so the key can never be extracted from the app
binary.

## Deploy (free tier is enough)

1. Create a free account at https://dash.cloudflare.com/sign-up if you
   don't have one.
2. Install Wrangler (Cloudflare's CLI) and log in:
   ```
   npm install -g wrangler
   wrangler login
   ```
3. From this folder, deploy the worker:
   ```
   cd server/groq-proxy
   wrangler deploy
   ```
4. Set your real Groq API key as a secret (get one at
   https://console.groq.com/keys if you don't have one — never put it
   in any file in this repo):
   ```
   wrangler secret put GROQ_API_KEY
   ```
5. Wrangler prints the worker's public URL after deploy, e.g.
   `https://mera-tun-groq-proxy.<your-subdomain>.workers.dev`. That's
   the value to use for `GROQ_PROXY_URL` in the app (see
   `AppConfig.groqProxyUrl` in `lib/app/app_config.dart`, and
   `GROQ_PROXY_URL` in `.env.example` / `codemagic.yaml`).

## No Cloudflare account / prefer another host?

The same `worker.js` logic (parse `{messages}`, add the Groq API key +
model server-side, forward to Groq, return the response) works as a
Vercel Edge Function, an AWS Lambda, or any small Node/Express route —
adapt the `fetch` handler to whatever platform you use. The only
requirement from the app's side is: a public HTTPS endpoint that
accepts `POST {"messages": [...]}` and returns Groq's JSON response.

## Testing it

```
curl -X POST https://<your-worker-url> \
  -H "Content-Type: application/json" \
  -d '{"messages":[{"role":"user","content":"hello"}]}'
```

Should return a Groq chat completion JSON body (not an error).
