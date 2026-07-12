export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') return res.status(200).end();

  const url   = process.env.KV_REST_API_URL;
  const token = process.env.KV_REST_API_TOKEN;
  if (!url) return res.status(500).json({ error: 'storage not configured' });

  const kv = (cmd) =>
    fetch(url, {
      method:  'POST',
      headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' },
      body:    JSON.stringify(cmd),
    }).then(r => r.json());

  if (req.method === 'GET') {
    const data = await kv(['ZREVRANGE', 'leaderboard', 0, 9, 'WITHSCORES']);
    const raw  = data.result || [];
    const scores = [];
    for (let i = 0; i < raw.length; i += 2) {
      scores.push({ name: String(raw[i]).split(':')[0], score: Number(raw[i + 1]) });
    }
    return res.json({ scores });
  }

  if (req.method === 'POST') {
    let raw = '';
    for await (const chunk of req) raw += chunk;
    const { name, score } = JSON.parse(raw);
    const safeName  = String(name || '').replace(/[^a-zA-Z0-9 _\-]/g, '').trim().slice(0, 12) || 'GI Joe';
    const safeScore = Math.min(9999999, Math.max(0, Number(score) | 0));
    const member    = `${safeName}:${Date.now()}`;
    await kv(['ZADD', 'leaderboard', safeScore, member]);
    await kv(['ZREMRANGEBYRANK', 'leaderboard', 0, -101]);
    return res.json({ ok: true });
  }

  return res.status(405).end();
}
