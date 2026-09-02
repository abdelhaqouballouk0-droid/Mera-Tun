// Cloudflare Worker: Groq chat proxy for Mera Tun.
//
// Holds the real Groq API key server-side (as a Wrangler secret) so it
// never ships inside the Flutter app binary. The client only ever knows
// this worker's public URL, which has nothing secret in it.
//
// Request:  POST { "messages": [{ "role": "user"|"assistant", "content": "..." }, ...] }
// Response: forwards Groq's chat completion response body verbatim.

const GROQ_URL = 'https://api.groq.com/openai/v1/chat/completions';
const GROQ_MODEL = 'openai/gpt-oss-120b';
const ALLOWED_ROLES = new Set(['user', 'assistant']);
const MAX_MESSAGES = 12;

export default {
  async fetch(request, env) {
    if (request.method !== 'POST') {
      return jsonResponse({ error: 'method_not_allowed' }, 405);
    }

    let payload;
    try {
      payload = await request.json();
    } catch {
      return jsonResponse({ error: 'invalid_json' }, 400);
    }

    const rawMessages = Array.isArray(payload?.messages) ? payload.messages : [];
    const messages = rawMessages
      .filter(
        (m) =>
          m &&
          ALLOWED_ROLES.has(m.role) &&
          typeof m.content === 'string' &&
          m.content.trim().length > 0,
      )
      .slice(-MAX_MESSAGES)
      .map((m) => ({ role: m.role, content: m.content }));

    if (messages.length === 0) {
      return jsonResponse({ error: 'no_messages' }, 400);
    }

    let groqResponse;
    try {
      groqResponse = await fetch(GROQ_URL, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${env.GROQ_API_KEY}`,
        },
        body: JSON.stringify({ model: GROQ_MODEL, messages }),
      });
    } catch {
      return jsonResponse({ error: 'upstream_unreachable' }, 502);
    }

    const body = await groqResponse.text();
    return new Response(body, {
      status: groqResponse.status,
      headers: { 'Content-Type': 'application/json' },
    });
  },
};

function jsonResponse(obj, status) {
  return new Response(JSON.stringify(obj), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}
