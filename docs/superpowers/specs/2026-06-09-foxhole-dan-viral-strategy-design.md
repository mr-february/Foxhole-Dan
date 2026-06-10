# Foxhole Dan — Steam Viral Strategy Design

**Date:** 2026-06-09  
**Target platform:** Steam (starting from zero — no page yet)  
**Goal:** Build and ship the game with the content and store presence needed to go viral on Steam

---

## Context

Foxhole Dan is a side-scrolling mature shooter about a decorated war veteran whose PTSD won't let him come home. The concept: normal mode = civilian world, PTSD mind perceiving threats; flashback mode = actual combat memories. Currently all rooms are combat. The civilian/PTSD duality is the untapped viral hook.

The game has 6 rooms: Title → Room1 (on foot) → Room2 (vehicle run) → Room3 (The Climb, vertical puzzle) → Room4 (bomb defusal) → Room5 (tower defense waves). No ending yet.

---

## Approach

Two game-side additions + Steam store work:

1. **PTSD Bleed Mechanics** — layer civilian intrusions over existing combat rooms without changing gameplay
2. **Civilian Ending (Room6)** — ambiguous payoff after Room5
3. **Steam Achievements** — 10 thematic achievements
4. **Steam Store Page** — narrative-first positioning, capsule art direction, trailer structure, Next Fest demo

---

## Section 1: PTSD Bleed Mechanics

Applied to existing combat rooms (especially Room1 and Room3). Three types:

### Audio Intrusions
- Every 60–120 seconds (randomized), a civilian sound plays softly over combat audio
- Examples: phone ringing, car horn, child's voice saying "Dad"
- Fades out over 2–3 seconds
- Implemented as a timer in `obj_controller` / `obj_controller3`

### Enemy Flicker
- Each enemy soldier has a small random chance per step to flash to a civilian sprite for 2–3 frames
- Civilian sprite: unarmed, hands up — same dimensions as `spr_enemy_soldier`
- New sprite: `spr_civilian` (18×30, matching enemy soldier dimensions)
- Handled in `obj_enemy_soldier` Draw event
- Subtle enough that players aren't sure they saw it

### Text Fragments
- Semi-transparent text appears at screen edge for ~90 frames
- Examples: *"just getting milk"* / *"kids are home at 4"* / *"it's not real"*
- Triggered by the same timer as audio intrusions
- Drawn in `obj_controller` / `obj_controller3` Draw_64 event
- Not every room — Room1 and Room3 only

### Clarity Pickup Integration
- `obj_clarity` (already exists) suppresses all bleed effects for 30 seconds after collection
- Thematic read: medication, grounding techniques
- No mechanical change — just add a `clarity_timer` global that bleed effects check before firing

---

## Section 2: Civilian Ending (Room6)

Triggers after Room5's final wave ends. A new room: 1920×768, no enemies, no collision, no gameplay.

### The Scene
- Dan sits at a kitchen table in civilian clothes (plain shirt, slumped posture, hand around a mug)
- Drawn entirely in GML draw code — no new sprite sheet needed
- A window on the right side of the room shows a quiet street
- Depth -9999 controller object handles the sequence

### Ambiguity Layers

**Sound:** Combat music fades but doesn't fully stop. Distant gunfire, very low volume — could be a TV, could be real.

**Visual echo:** The window flickers once to Room2's terrain heightmap silhouette. Gone in 2 frames. Players may not be certain they saw it.

**Text:** Two lines appear sequentially, semi-transparent, then fade:
> *He made it home.*  
> *He always makes it home.*

### Pacing
- No button prompt, no "press space"
- Total scene: ~8 seconds
- Fades to black automatically
- Credits or plain black — no score, no grade, no "you win"

---

## Section 3: Steam Achievements

| Internal Name | Display Name | Trigger | Notes |
|---|---|---|---|
| `ach_room1` | Still Standing | Complete Room1 | |
| `ach_room2` | The Long Road | Complete Room2 | |
| `ach_room3` | The Climb | Complete Room3 | Double meaning intentional |
| `ach_room4` | Defused | Complete Room4 | Double meaning intentional |
| `ach_room5` | Hold the Line | Complete Room5 | |
| `ach_ending` | He Made It Home | See Room6 ending | Ambiguous |
| `ach_deaths` | Ghost | Die 25 times | Self-aware |
| `ach_clarity` | It's Not Real | Collect all clarity pickups | Thematic |
| `ach_playtime` | 100 Days | Accumulate 100 minutes playtime | Heavy, no explanation |
| `ach_flicker` | I See Them Too | Witness 10 enemy flickers | Secret — rewards noticing |

`100 Days` and `I See Them Too` are the most shareable. The secret achievement rewards players who noticed the flicker mechanic and will generate community discussion.

GMS2 integration: use `steam_set_achievement("ach_name")` at the relevant trigger points.

---

## Section 4: Steam Store Page

### Positioning
Do NOT market as a shooter. Market as a psychological experience that contains a shooter.

**Short description:**
> *A decorated veteran fights his way through war. Or through something that looks like war.*

### Tags (order matters)
1. Psychological Horror
2. Story Rich
3. Action
4. Indie
5. Shoot 'Em Up

Leading with Psychological Horror places the game alongside Hellblade, Devotion, and Paratopic — a smaller audience that reviews loudly and drives word-of-mouth.

### Capsule Art Direction
- Dan in silhouette, split vertically down the middle
- Left half: combat gear, helmet, weapon
- Right half: civilian clothes, plain shirt
- Dark background, no explosions
- The image asks a question rather than showing action

### Trailer Structure (60 seconds)
- **0–10s:** Black screen. Civilian ambient sound. A mundane spoken line. Then: gunfire.
- **10–40s:** Gameplay — enemy flicker visible, PTSD text fragments, vehicle run terrain, The Climb
- **40–55s:** Kitchen table. The two lines of text appear.
- **55–60s:** Title card. *Foxhole Dan.* No tagline.

### Steam Next Fest Demo
- Cover Room0 (title) through Room2 (vehicle run)
- Enough variety to show tonal range
- Leaves Room3–Room6 as mystery
- Room2 ends with a hard cut — no transition, no "to be continued"

---

## What This Is Not

- Not a mechanics overhaul — all existing gameplay stays as-is
- Not a full civilian prologue room — the civilian world appears only in fragments and the ending
- Not a difficulty redesign — difficulty system already exists and scales correctly

---

## Open Questions

- Civilian sprite (`spr_civilian`) dimensions and design — needs asset creation
- Steam developer account setup (separate from game design)
- Kevin MacLeod attribution placement in credits/store page
- Whether Room6 needs its own background music or silence is more effective
