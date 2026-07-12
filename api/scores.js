// Foxhole Dan — global leaderboard endpoint (Vercel serverless + Vercel KV).
//   GET  /api/scores?board=endless        -> { scores: [ {initials, wave, score}, ... ] } (top 100)
//   POST /api/scores  { board, initials, score, wave } -> { ok, scores }
//
// Provisioning (one-time, in the Vercel dashboard):
//   Storage -> Create Database -> KV -> connect to this project. That injects
//   KV_REST_API_URL / KV_REST_API_TOKEN automatically. No code change needed.
import { kv } from '@vercel/kv';

function cleanBoard(b) {
  b = String(b || 'endless').replace(/[^a-z0-9_]/gi, '').slice(0, 20);
  return b || 'endless';
}

function decode(raw, score) {
  const parts = String(raw).split('|');
  return { initials: parts[0] || 'AAA', wave: Number(parts[1]) || 0, score: Number(score) || 0 };
}

async function topScores(key) {
  // withScores returns a flat [member, score, member, score, ...] array.
  const raw = await kv.zrange(key, 0, 99, { rev: true, withScores: true });
  const out = [];
  for (let i = 0; i < raw.length; i += 2) out.push(decode(raw[i], raw[i + 1]));
  return out;
}

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') return res.status(200).end();

  const board = cleanBoard(req.query && req.query.board);
  const key = 'lb:' + board;

  try {
    if (req.method === 'GET') {
      return res.status(200).json({ scores: await topScores(key) });
    }

    if (req.method === 'POST') {
      let body = req.body;
      if (typeof body === 'string') { try { body = JSON.parse(body); } catch (e) { body = {}; } }
      body = body || {};

      const initials = (String(body.initials || 'AAA').toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 3)) || 'AAA';
      const score = Math.max(0, Math.min(99999999, parseInt(body.score, 10) || 0));
      const wave  = Math.max(0, Math.min(9999, parseInt(body.wave, 10) || 0));

      // Reject implausible runs (deterrent only — a web game can't be fully trusted).
      // Rough heuristic cap per wave; the old `score < wave * 1e8` bound was always true
      // for any valid score (clamped to 99,999,999) so it rejected nothing. Retune once
      // the board is live and real score distributions are visible.
      if (score > 0 && score <= (wave + 1) * 100000) {
        const nonce = Date.now().toString(36) + Math.random().toString(36).slice(2, 8);
        const member = initials + '|' + wave + '|' + nonce;
        await kv.zadd(key, { score, member });
        // Keep only the top 100.
        const count = await kv.zcard(key);
        if (count > 100) await kv.zremrangebyrank(key, 0, count - 101);
      }
      return res.status(200).json({ ok: true, scores: await topScores(key) });
    }

    return res.status(405).json({ error: 'method_not_allowed' });
  } catch (e) {
    // KV not provisioned yet, or a transient error — fail soft so the game stays playable.
    return res.status(200).json({ scores: [], offline: true, detail: String((e && e.message) || e) });
  }
}
