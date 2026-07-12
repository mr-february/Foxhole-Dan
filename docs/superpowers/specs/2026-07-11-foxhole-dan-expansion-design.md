# Foxhole Dan — Expansion Design Spec

**Date:** 2026-07-11
**Status:** Approved design → implementation planning
**Project:** `C:\Users\mrwil\Desktop\Foxhole-Dan` (GameMaker Studio 2, IDE `2024.14.4.222`, HTML5 export → Vercel)

---

## 1. Goals

Expand Foxhole Dan from a 6-room game into a full campaign with a coherent narrative, a deep enemy roster, addictive replayability, and a global online leaderboard.

Concretely:
1. **Longer campaign** — grow to **13 rooms (12 playable levels + ending)** by adding **7 new rooms** and reskinning the 6 existing rooms. Keep the existing finale rooms (Room4 bomb-defuse, Room5 tower-defense, Room6 ending) as the climax.
2. **Coherent setting** — replace the muddled WWII/1961 frame with a braided **Vietnam (trauma) + 1983 present (conspiracy)** story.
3. **More enemies** — ~10 new enemy types + new/reskinned bosses, tiered so difficulty escalates.
4. **Addictive replayability** — a combo-scoring system across the whole game plus an unlockable **Endless Survival** mode.
5. **Global online leaderboard** — Vercel serverless API + Vercel KV; boards for Endless score and campaign speedrun.
6. **More cutscenes** — rewrite the 2 existing cutscenes and add ~4 new ones, all coherent to the new setting.

**Non-goals (this spec):** new audio pipeline overhaul beyond adding needed tracks; Steam store/marketing changes; mobile/Capacitor wrappers.

---

## 2. Architecture constraints (from codebase recon)

These are hard facts about the current engine that the design must respect:

- **No `scripts/` folder, no object inheritance.** Every `.yy` has `parentObjectId: null`. All logic is inline per-event GML. All art is procedural (`draw_rectangle`/`draw_line` in `Draw_0`).
- **Rooms contain zero placed instances.** Every room's `.yy` has empty `"instances":[]`; all objects spawn from `rooms/RoomN/RoomCreationCode.gml`. Adding a level = register room in `.yyp` (`resources` + `RoomOrderNodes`) + write creation code + write a controller object.
- **Enemies have no shared parent.** Every player projectile hard-codes each enemy type via `instance_place(obj_specific)` (or a distance loop for spriteless enemies), and **scoring is duplicated inline at each kill site** (`obj_bullet`, `obj_grenade`, `obj_vehicle_bullet`, `obj_boss`, `obj_td_*`).
- **Transitions are explicit `room_goto(RoomN)`** calls, not `room_next`. Cutscenes are objects that a level spawns on win (setting `global.game_state = 3`); they `room_goto` at their end.
- **`obj_controller` (Room1's) is the only persistent object.** Levels after Room1 must guard with `with (obj_controller) instance_destroy();` in creation code, OR use non-persistent controllers (controllers 2–6 already are). New controllers will be non-persistent.
- **Existing meta-state:** `global.score` (raw total, kill sites add 100–1000), `global.high_score` (persisted to `foxhole_dan.ini` `[saves]`), `global.difficulty` (0–3), `global.game_state` (0 play,1 win,2 dead,3 cutscene), plus PTSD/clarity/flashback system, screen-shake/flash globals, and Steam achievements. **No combo, kill counter, timer-scoring, or per-run stats today.**

---

## 3. Foundation refactor (Phase 0 — prerequisite)

Do this before adding content; it makes every later enemy/weapon/scoring change trivial and avoids N× duplicated edits.

### 3.1 `scripts/` folder + centralized helpers
Create `scripts/` and register a script resource in `Foxhole-Dan.yyp`. Add:
- `scr_award_kill(enemy_inst)` — single source of truth for a kill: reads `enemy_inst.score_value`, adds `score_value × global.combo_mult` to `global.score`, increments `global.run_kills`, bumps combo (see 3.3), triggers kill FX (shake/flash/kill_flash), and plays the death SFX. Replaces the duplicated scoring blocks in every projectile.
- `scr_spawn_gore(x, y, facing)` — the corpse/gore-part/blood/decal burst currently copy-pasted in `obj_bullet`.
- `scr_hit_enemy(enemy_inst, dmg, hitx, hity)` — apply damage, hit_flash, damage-number, blood; if `hp <= 0` call `scr_award_kill` + `scr_spawn_gore` + destroy. Weapons call this instead of inlining.

### 3.2 `par_enemy` parent object
Create `par_enemy` (no events, or shared defaults). Reparent all damageable enemies to it: `obj_enemy_soldier`, `obj_enemy_bomber`, `obj_enemy_vehicle`, `obj_boss`, all new enemy types, and (where practical) the TD enemies. Each enemy sets in Create: `score_value`, `hp`, `max_hp`, `hit_flash`, `is_civilian_flicker` (bool).
- Player weapons change from N `instance_place(obj_specific)` calls to a single `instance_place(par_enemy)` → `scr_hit_enemy(hit, dmg, x, y)`.
- Spriteless enemies (bomber-style) still need a mask sprite OR keep a distance-loop fallback; prefer giving each a collision-mask sprite so `instance_place(par_enemy)` works uniformly.

### 3.3 Combo / run-stat globals
Add and initialize (in `obj_controller/Create_0.gml` + each room creation code + a shared `scr_init_run()`):
- `global.combo_count` (kills in current combo window), `global.combo_mult` (1–8), `global.combo_timer` (frames until combo resets, e.g. 150), `global.run_kills`, `global.run_time` (frames, ticked by active controller), `global.run_hits_taken` (for no-hit bonus), `global.run_style` (headshot/grenade-multikill bonuses).
- Combo rules: each kill sets `combo_timer` to full and increments `combo_count`; `combo_mult = clamp(1 + floor(combo_count/4), 1, 8)`. When `combo_timer` hits 0, reset `combo_count`/`combo_mult` to base.
- HUD: draw current combo multiplier + a shrinking combo timer bar (in the active controller's `Draw_64`).

### 3.4 Persistence expansion
Extend `foxhole_dan.ini` `[saves]` with: `high_score`, `endless_best_score`, `endless_best_wave`, `campaign_best_time`, `total_kills`, plus an `[unlocks]` and `[cache]` section (last submitted initials, cached leaderboard JSON for offline display). Add a `scr_save_stat(key, value_if_better)` helper.

---

## 4. Setting & narrative bible

### 4.1 Timelines
- **[V] Vietnam (flashback / trauma).** ~1968–70. Jungle, a river, and the **bunker/foxhole** where it happened. Dan (Pvt. **Danilo "Dan"**) and Sgt. **Hayes**, who carried Dan two miles through enemy fire and was later declared **KIA**. The trauma: an incident at the river/bunker that Dan's memory has buried.
- **['80s] Present (conspiracy).** **1983.** Dan is a burned-out veteran. Anonymous letters signed **"H"** have been engineering his breakdown. The truth: **Project FOXHOLE (program cryptonym MK-ECHO)** — a Cold-War mind-control program run by defense-intelligence figure **Harrington ("H")** that reverse-engineered Dan's foxhole trauma into a psychological weapon and used **Dan himself as a test subject** (Veteran ID 44-7821). The title of the game is literally the name of the program that broke him.

### 4.2 Themes / tone
Jacob's Ladder + Manchurian Candidate. The existing **PTSD "civilian flicker"** mechanic (enemies momentarily render as unarmed civilians; killing them raises `global.ptsd_flicker_count`; `obj_clarity` pickups suppress it) is the moral spine — Vietnam guilt made literal, and MK-ECHO's flashbacks bleeding into the present.

### 4.3 Name registry (locked)
| Role | Name |
|------|------|
| Protagonist | **Dan (Danilo)**, Veteran ID 44-7821 |
| Battle-buddy / saved him | **Sgt. Hayes** |
| Antagonist | **Harrington / "H"** |
| Program | **Project FOXHOLE** (cryptonym **MK-ECHO**) |
| TD boss (reskinned Reyes) | **Reyes** — Harrington's field enforcer |
| Present-day boss | **The Handler** (Harrington's proxy) |

---

## 5. Level lineup (13 rooms)

`[V]` = Vietnam flashback, `['80s]` = 1983 present. "Source" = new room or reskinned existing room.

| # | Level | Timeline | Mechanic | Source room |
|---|-------|----------|----------|-------------|
| 1 | **The Bunker** | V | run-and-gun (origin firefight, the trauma begins) | reskin **Room1** |
| 2 | **Cold Sweat** | '80s | **NEW: stealth** — apartment/VA, alert meter, silent takedowns | new **Room7** |
| 3 | **The River** | V | riverboat driving-shooter (PBR patrol down the river) | reskin **Room2** |
| 4 | **Overwatch** | '80s | **NEW: sniper/scope** — pinned on a rooftop, scoped precision fire | new **Room8** |
| 5 | **The Ambush** | V | grapple-climb under mortars (escape up a cliff/waterfall) | reskin **Room3** |
| 6 | **Dust-Off** | '80s | **NEW: on-rails chopper gunner** | new **Room9** |
| 7 | **Downriver** | V | **NEW: swim/dive** — sunken boat, air meter, underwater hazards | new **Room10** |
| 8 | **The Facility** | '80s | run-and-gun through the MK-ECHO lab | new **Room11** |
| 9 | **Interrogation** | '80s | **NEW: interrogation** — resist/branch QTE sequence | new **Room12** |
| 10 | **The Chair** | '80s | bomb-defuse QTE (MK-ECHO's final trap) | keep **Room4** |
| 11 | **The Mountain** | '80s | **NEW: hazard-dodge climb** — avalanches, boulders, ice, crumbling ledges, wind | new **Room13** |
| 12 | **The Siege** | '80s | tower-defense — *defend Dan's mountaintop home* | keep **Room5** |
| 13 | **Home** | — | ending cinematic | keep **Room6** |

**Room numbering:** New rooms are `Room7`–`Room13`. Because flow is explicit `room_goto`, physical room numbers need not match play order; the play order is defined by the goto chain below. New GameMaker rooms are named `Room7..Room13`; the *display level number* shown to players is separate (stored per-controller as `level_no`).

**Goto chain (final):**
`Room0 (title) → Room1 → Room7 → Room2 → Room8 → Room3 → Room9 → Room10 → Room11 → Room12 → Room4 → Room13 → Room5 → Room6 → Room0`
(with cutscene objects inserted at the story beats in §9).

### 5.1 Mechanic specs (new levels)

**Cold Sweat (stealth).** Side-view stealth. Dan unarmed or pistol-only; enemy guards have vision cones (draw a cone via `draw_triangle`/alpha) and an **alert meter**. Crouch (existing `crouching`) reduces detection; shadow zones (dark overlay regions) hide Dan. Silent takedown when adjacent + behind a guard (new input, e.g. reuse melee/grenade key contextually). Full alert → guards swarm (spawns reinforcements) and level becomes a fight. Win = reach the exit. Reuses `obj_dan` movement; new `obj_guard` (par_enemy) with vision/alert AI; new controller tracks global alert.

**Overwatch (sniper).** Fixed or slow-panning camera on a rooftop. Zoomed **scope** overlay (dim screen + circular scope drawn in GUI, magnified aim). Enemies advance across the street in waves; scoped shots are one-shot kills with travel time; missing/slow lets them reach cover and suppress Dan (damage). Win = survive N waves / clear the street. New scope-aim input mode toggled on `obj_dan` or a dedicated `obj_dan_sniper`. Introduces the **Sniper** enemy as antagonist counter (enemy snipers with laser tells).

**Dust-Off (on-rails chopper).** Auto-scrolling on-rails. Dan mans a door gun; camera moves along a fixed path; reticle-aim across the screen; targets (ground troops, technicals, RPG teams, other choppers) appear and must be cleared before they damage the chopper (chopper has an HP bar). Win = reach the LZ. New `obj_dan_chopper` (fixed position, free reticle aim) + `obj_heli_target` spawner in the controller. Reuses projectile/damage system.

**Downriver (swim/dive).** Vertical/horizontal swim. **Air meter** (surface to refill); underwater currents push Dan; hazards (mines, debris, enemy divers, propellers). Reduced-gravity swim physics (reuse rope half-grav pattern). Win = reach the far bank. New `obj_dan_swim` movement variant + `obj_air_bubble`, `obj_river_mine`, `obj_enemy_diver` (par_enemy).

**The Facility (run-and-gun).** Standard run-and-gun on the existing `obj_dan`, but in the MK-ECHO lab: new tileset visuals, lab hazards (electric floors, gas), heaviest mix of '80s enemies, mid-level reveal cutscene. Reuses Room1 architecture.

**Interrogation (interrogation QTE/branch).** Self-contained minigame in the Room4 (bomb-defuse) engine style: a `phase` state machine, timed inputs to **resist interrogation** (mash to hold out, directional inputs to deflect, hold combos). Branches: resist fully → learn the truth cleanly; break → distorted/unreliable version. Outcome sets a flag read by later cutscenes/ending. New `obj_controller_interro` modeled on `obj_controller4`.

**The Mountain (hazard-dodge climb).** Vertical platformer (tall room like Room3, e.g. 1920×3500+). Player ascends on platforms; the controller owns the camera (like `obj_controller3`). Hazards spawned on timers by the controller:
- **Avalanches** — sweeping snow bands descending from above; must shelter behind rock outcrops or be in a safe lane.
- **Boulders** — `obj_boulder` rolling/bouncing down slopes, physics + platform collision, instant heavy damage on contact.
- **Falling ice / crumbling ledges** — platforms that break shortly after Dan stands on them (timer), forcing constant upward movement.
- **Wind gusts** — periodic horizontal force pushing Dan (reuse the vehicle terrain-force pattern).
Win = reach the summit (`player.y < threshold`) → Dan's home in view. Enemies optional/light (this level is about environment). New `obj_boulder`, `obj_avalanche`, `obj_crumbling_platform`, `obj_wind_zone`, `obj_controller_mtn`.

---

## 6. Enemy roster

All new enemies inherit `par_enemy`, set `score_value`, and are hit uniformly by all weapons via `scr_hit_enemy`. Each has a Vietnam and an '80s visual variant selected by a `variant` var (procedural draw switches palette/silhouette). Several set `is_civilian_flicker = true`.

| Enemy | Behavior | Key stats | Signature |
|-------|----------|-----------|-----------|
| **Heavy / Armored** | slow, high HP, i-frames, tanks hits | hp high, `i_frames` on hit | absorbs fire, needs grenades |
| **Sniper** | long range, laser-sight tell, one big shot | huge `shoot_range`, long `shoot_timer`, fast bullet | telegraph line before firing |
| **RPG / Rocket** | fires slow AoE rocket (new `obj_rocket`) | med hp, AoE damage | forces movement |
| **Attack Dog (K9)** | fast, melee/contact damage, no ranged | high `move_spd`, contact dmg | rushes, hard to hit |
| **Flamethrower** | short-range particle cone (new `obj_flame`) | low-med hp, cone dmg | deadly up close |
| **MG Nest** | static, rapid suppressive fire | `move_spd=0`, fast `shoot_timer` | area denial |
| **Medic** | heals nearby enemies over time | low hp, heal pulse | priority target |
| **Elite Operative** | fan-fire spread (boss-style), body armor | med-high hp | mini-boss pressure |
| **Sapper / Grenadier** | rushes then explodes (satchel) | low hp, big contact AoE | suicide rush |
| **Ambusher** | spawns from cover/tunnel on approach | med hp, surprise | punishes rushing |

**Bosses:**
- **The Sergeant** (existing Room1 boss) → reskinned as the Vietnam trauma figure; 2-phase fan-fire + charge stays.
- **Reyes** (existing TD boss) → Harrington's enforcer; kept in The Siege.
- **The Handler** (new) — present-day boss for The Facility or Interrogation climax; multi-phase, uses several roster enemies as adds.

Difficulty scaling reuses the existing `global.difficulty` (0–3) stat-table pattern from `obj_enemy_soldier`/`obj_boss`.

---

## 7. Replayability

### 7.1 Combo scoring (campaign-wide)
Defined in §3.3. Applies in every level. HUD shows multiplier + combo timer. This alone makes the campaign score-chaseable.

### 7.2 Endless Survival mode
- **Unlock:** after first campaign completion (`[unlocks] endless=1` in ini). Selectable from the title screen.
- **Room:** new `Room_endless` (`Room14`) + `obj_controller_endless`, modeled on the TD wave loop (`obj_controller5`) but for the run-and-gun `obj_dan` in an arena.
- **Loop:** infinite escalating waves. Each wave draws from the full roster with rising counts/tiers; every Nth wave is a **boss wave**. Between waves, brief shop/heal (optional: spend score or pickups).
- **Scoring:** `wave_clear_bonus + Σ(kill score × combo) + time bonus + no-hit bonus`. Run ends on death.
- **End of run:** show run stats → enter 3 initials → submit to leaderboard (§8) → show local + global rank.

### 7.3 Unlocks (light meta, optional/stretch)
`[unlocks]` in ini gated on best score/wave: e.g. alternate loadout (faster reload / bigger mag), a harder "Brutal+" modifier, cosmetic palette. Kept minimal to control scope; can be cut without affecting core.

---

## 8. Online leaderboard

### 8.1 Backend (Vercel)
- Add serverless functions under `api/` in the repo (Vercel auto-serves `api/*` alongside the static `html5game` output — note current `outputDirectory` is `html5game`; confirm `api/` is picked up, else adjust `vercel.json`).
- **Storage:** **Vercel KV** (Redis). Sorted sets per board: `lb:endless`, `lb:speedrun`. Member = `initials|nonce`, score = points (or negative time for speedrun so ascending = fastest).
- **Endpoints:**
  - `GET /api/scores?board=endless&limit=100` → `{ "scores": [ { "initials": "ABC", "score": 12345, "wave": 22, "ts": ... }, ... ] }` (top 100).
  - `POST /api/scores` body `{ board, initials, score, wave, time, mode, checksum }` → validates, inserts, returns new rank + top slice.
- **Anti-cheat (light, best-effort for a web game):** server-side clamp to sane maxima; require a `checksum` = obfuscated hash of `score+wave+salt` computed client-side and re-derived server-side; rate-limit by IP; sanitize `initials` to `[A-Z0-9]{1,3}`. Documented as deterrent-only.
- **Provisioning (user step):** enable Vercel KV on the project in the dashboard and link it; env vars (`KV_REST_API_URL`, `KV_REST_API_TOKEN`) are injected automatically. Exact click-path documented in the implementation plan.

### 8.2 Client (GML)
- HTTP via `http_post_string` / `http_get`; responses handled in the **Async HTTP** event (`Other → Async - HTTP`) on a new `obj_net` object; parse with `json_parse`.
- **Submit flow:** after an Endless run (or campaign finish for speedrun), collect 3 initials (reuse existing keyboard/gamepad input), POST, then display global rank.
- **Display:** leaderboard screen reachable from the title (`obj_title_controller` gains a "LEADERBOARD" menu entry) and shown post-run. Renders top 100 with scroll.
- **Offline fallback:** on request failure, show cached JSON from ini `[cache]` and the local `high_score`; queue the submit for retry next launch.
- **CORS/COEP:** API is same-origin (same Vercel deployment) so the existing `Cross-Origin-Opener-Policy: same-origin` / `Cross-Origin-Embedder-Policy: require-corp` headers do not block it. Verify no third-party origin is introduced.

---

## 9. Cutscenes

Reuse the procedural panel/slide state machine (`obj_cutscene` pattern: `Create` sets `panels`+music; `Step` advances on input and `room_goto`s at the end; `Draw_64` holds a `switch(panel)` of composed helper-art + text boxes with letterbox/prompt/fade footer).

- **Rewrite** `obj_cutscene` (currently 10 panels, WWII→extraction) and `obj_cutscene2` (7 panels) to the Vietnam/'80s story.
- **New cutscenes** (~4) at key beats, each its own `obj_cutsceneN` registered in `.yyp`:
  - **Opening** — Vietnam, the bunker, Hayes' promise (before Level 1).
  - **The break** — 1983, the letters, Dan realizes someone engineered his nightmares (mid-game).
  - **The reveal** — MK-ECHO / Project FOXHOLE files (before/inside The Facility or Interrogation).
  - **Pre-summit / pre-siege** — Dan reaches the mountain, the enforcers close in (before The Siege).
- **New procedural art helpers** needed: `cs_jungle`, `cs_river`, `cs_apartment`, `cs_rooftop`, `cs_chopper`, `cs_facility`, `cs_mountain`, `cs_harrington` (the antagonist). Reuse `cs_dan`, `cs_hayes`, `cs_box`, `cs_narrate`, letterbox/fade footer.
- Interrogation outcome flag (§5.1) selects alternate lines in the reveal/ending cutscenes.

---

## 10. Component inventory (what gets created)

**Scripts (new `scripts/`):** `scr_award_kill`, `scr_hit_enemy`, `scr_spawn_gore`, `scr_init_run`, `scr_save_stat`, `scr_combo_tick`, `scr_net_submit`, `scr_net_fetch`.

**Objects (new):** `par_enemy`; enemies `obj_enemy_heavy`, `obj_enemy_sniper`, `obj_enemy_rocket`, `obj_enemy_dog`, `obj_enemy_flamer`, `obj_mg_nest`, `obj_enemy_medic`, `obj_enemy_elite`, `obj_sapper`, `obj_ambusher`, `obj_guard`, `obj_enemy_diver`; boss `obj_boss_handler`; projectiles/hazards `obj_rocket`, `obj_flame`, `obj_boulder`, `obj_avalanche`, `obj_crumbling_platform`, `obj_wind_zone`, `obj_river_mine`, `obj_air_bubble`; player variants `obj_dan_chopper`, `obj_dan_swim` (or mode flags on `obj_dan`), sniper scope handled on `obj_dan`; controllers `obj_controller7..13`, `obj_controller_interro`, `obj_controller_mtn`, `obj_controller_endless`; net `obj_net`; new cutscenes `obj_cutscene3..6`.

**Rooms (new):** `Room7..Room13` (+ `Room14` endless), each with `RoomN.yy` + `RoomCreationCode.gml`, registered in `.yyp` `resources` + `RoomOrderNodes`.

**Sounds (new/needed):** additional level music tracks (reuse or generate via `gen_music.ps1`), SFX for takedown, scope, chopper, splash/underwater, boulder/avalanche.

**Backend:** `api/scores.js` (+ any shared lib), Vercel KV, possible `vercel.json` tweak.

**Modified existing:** all player projectiles (route through `scr_hit_enemy`); `obj_dan`/`obj_dan_vehicle` (combo hooks, mode variants); `obj_controller` + all controllers (combo HUD, run-stat ticks); `obj_title_controller` (Endless + Leaderboard menu, unlock read); `obj_boss`/`obj_td_*`/`obj_enemy_*` (reparent, `score_value`); `obj_cutscene`/`obj_cutscene2` (rewrite); reskin room creation code + backgrounds; `foxhole_dan.ini` schema.

---

## 11. Data flow

1. **Kill:** weapon Step → `instance_place(par_enemy)` → `scr_hit_enemy(hit,dmg,x,y)` → on death `scr_award_kill` (score×combo, run_kills++, combo bump) + `scr_spawn_gore` → FX globals (shake/flash) → controller `Draw_64` renders HUD/combo.
2. **Level flow:** controller detects win → `global.game_state=1`/spawn cutscene(`=3`) → cutscene `room_goto(next)`.
3. **Run stats:** active controller ticks `global.run_time`; damage to Dan increments `global.run_hits_taken`.
4. **End of run (endless):** controller → stats screen → initials → `scr_net_submit` (POST) → `obj_net` Async HTTP → parse rank → display; also `scr_save_stat` locally.
5. **Boot:** title reads ini (`high_score`, unlocks, cached board) → optional `scr_net_fetch` for live board.

---

## 12. Implementation phases (each independently testable)

- **Phase 0 — Foundation:** `scripts/`, `par_enemy`, reparent + reroute weapons, combo system, run-stat globals, ini schema, HUD combo. *Verify: existing 6 rooms still play; score/combo works; no regressions.*
- **Phase 1 — Narrative reskin:** rewrite `obj_cutscene`/`obj_cutscene2`; reskin Room1/2/3 visuals + text to Vietnam/'80s; name registry applied. *Verify: play rooms 1–3, cutscenes coherent.*
- **Phase 2 — Enemy roster:** 10 new enemy types + The Handler boss, tiered stat tables. *Verify: spawn each in a test room; all weapons hit; scoring correct.*
- **Phase 3 — New levels:** Room7–Room13 with their controllers + mechanics (stealth, sniper, chopper, swim, facility, interrogation, mountain); wire full goto chain + new cutscenes. *Verify: full campaign playthrough start→ending.*
- **Phase 4 — Endless + leaderboard:** Endless room/controller, unlock gating, `api/scores` + Vercel KV, `obj_net` client, submit/display/offline. *Verify: endless run submits and appears on global board; offline fallback works.*

Implementation to be driven by **Fable-model agents** per phase.

---

## 13. Testing / verification strategy

- GameMaker HTML5 is the ship target; verify via the HTML5 build (`docs/html5game` deploy) and in-IDE runs where possible. (Note: this environment cannot launch the GM IDE; runtime verification of GML requires the user or a build step — call out explicitly in the plan.)
- Per-phase manual playthrough checklist (above).
- Leaderboard: test POST/GET against a Vercel preview deployment with KV before merging; verify checksum rejection and initials sanitization.
- Regression: existing finale rooms (Room4/5/6) must remain fully playable after the refactor and reskin.

---

## 14. Open risks

- **GML runtime verification** can't happen headlessly here; relies on user/CI build. Plan must include explicit "user runs build X to verify" checkpoints.
- **Vercel `api/` + `outputDirectory: html5game`** interaction must be confirmed (may need a `vercel.json` routes tweak).
- **Vercel KV provisioning** is a manual user step (billing/plan). Local-only fallback keeps the game shippable if KV is delayed.
- **Scope**: 7 new levels + 10 enemies + backend is large; phasing + Fable agents mitigate, but Phases 3–4 are the long pole.
- **HTML5 leaderboard security** is best-effort only; acknowledged.
