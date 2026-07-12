# Foxhole Dan

A mature-audience side-scrolling shooter built in GameMaker Studio 2. A Vietnam
veteran (Dan, ID 44-7821) is hunted through his own trauma in 1983 by **Project
FOXHOLE / MK-ECHO** — a mind-control program that weaponized his nightmares.

## The Expansion (2026-07)

The game is now a **13-level campaign** braiding a Vietnam-1968 flashback with the
1983 conspiracy, plus an unlockable **Endless Survival** mode and a **global
leaderboard**. Levels: The Bunker → Cold Sweat (stealth) → The River → Overwatch
(sniper) → The Ambush → Dust-Off (chopper) → Downriver (swim) → The Facility
(+ The Handler boss) → Interrogation → The Chair → The Mountain → The Siege → Home.
Adds ~10 enemy types, a combo-multiplier scoring system, and rewritten cutscenes.

### Leaderboard setup (one-time, optional)

Endless scores submit to `/api/scores` (Vercel serverless + Vercel KV). To enable
the global board: in the Vercel dashboard → **Storage → Create Database → KV**,
and connect it to this project (injects `KV_REST_API_*` env vars automatically).
Until then the game is fully playable — it just keeps local high scores and shows
"offline (no board yet)". `outputDirectory` stays `html5game`; `api/` deploys
alongside it.

## Requirements

- **GameMaker Studio 2** — version **2024.14.4.222**  
  Download from [gamemaker.io](https://gamemaker.io) (sign in → IDE Downloads → select version 2024.14)

## Setup

1. Clone the repo
2. Open `Foxhole-Dan.yyp` in GameMaker Studio 2024.14.4.222
3. Press F5 to run

## Project notes

- All drawing is procedural GML — no external sprite dependencies except `spr_explosion_fx`
- Mature content — not suitable for children
