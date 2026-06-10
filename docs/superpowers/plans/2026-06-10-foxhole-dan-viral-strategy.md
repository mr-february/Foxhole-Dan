# Foxhole Dan Viral Strategy Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add PTSD bleed mechanics, a civilian ending (Room6), Steam achievements, and a store page document to make Foxhole Dan go viral on Steam.

**Architecture:** PTSD bleed effects are layered on top of existing controllers without changing gameplay. Room6 is a new non-interactive room driven by obj_controller6 using a timed phase sequence. Achievements use GMS2's built-in `steam_set_achievement()` which is a safe no-op when Steam isn't active.

**Tech Stack:** GameMaker Studio 2024.14.4 / GML, ffmpeg for audio generation, PowerShell for file ops

---

## File Map

| File | Action | Purpose |
|---|---|---|
| `objects/obj_controller/Create_0.gml` | Modify | Add PTSD globals, play-seconds counter |
| `objects/obj_controller/Step_0.gml` | Modify | PTSD bleed timer, text trigger, clarity tick, playtime |
| `objects/obj_controller/Draw_64.gml` | Modify | Text fragment rendering |
| `objects/obj_controller3/Step_0.gml` | Modify | PTSD bleed timer, text trigger, clarity tick |
| `objects/obj_controller3/Draw_64.gml` | Modify | Text fragment rendering |
| `objects/obj_enemy_soldier/Create_0.gml` | Modify | Add flicker_timer, flicker_cd vars |
| `objects/obj_enemy_soldier/Draw_0.gml` | Modify | Civilian flicker draw |
| `objects/obj_clarity/Step_0.gml` | Modify | Set global.clarity_timer, increment total_clarity, fire achievement |
| `objects/obj_cutscene/Step_0.gml` | Modify | Fire ach_room1 before Room2 |
| `objects/obj_dan/Step_0.gml` | Modify | Track total_deaths, fire ach_deaths |
| `objects/obj_dan_vehicle/Step_0.gml` | Modify | Fire ach_room2 at win |
| `objects/obj_controller3/Step_0.gml` | Modify | Fire ach_room3 before Room4 |
| `objects/obj_controller4/Step_0.gml` | Modify | Fire ach_room4 before Room5 |
| `objects/obj_controller5/Step_0.gml` | Modify | Fire ach_room5, redirect win to Room6 |
| `objects/obj_controller6/Create_0.gml` | Create | Room6 sequence init |
| `objects/obj_controller6/Step_0.gml` | Create | Phase progression, window flicker, fade |
| `objects/obj_controller6/Draw_64.gml` | Create | Kitchen table scene, Dan civilian, text |
| `objects/obj_controller6/obj_controller6.yy` | Create | Object definition |
| `rooms/Room6/Room6.yy` | Create | Room definition (1920×768) |
| `rooms/Room6/RoomCreationCode.gml` | Create | Spawn obj_controller6 |
| `sounds/snd_ptsd_ring/snd_ptsd_ring.yy` | Create | Sound definition |
| `sounds/snd_ptsd_ring/snd_ptsd_ring.wav` | Create | 880 Hz ring tone, 1.8 s |
| `sounds/snd_ptsd_horn/snd_ptsd_horn.yy` | Create | Sound definition |
| `sounds/snd_ptsd_horn/snd_ptsd_horn.wav` | Create | 220 Hz horn burst, 0.8 s |
| `Foxhole-Dan.yyp` | Modify | Register all new resources |
| `docs/steam-store-page.md` | Create | Store copy, tags, trailer script, capsule brief |

---

## Task 1: Global state additions

**Files:**
- Modify: `objects/obj_controller/Create_0.gml`

- [ ] **Step 1: Add PTSD globals and counters to obj_controller Create_0**

Append to the end of `objects/obj_controller/Create_0.gml`:

```gml
// PTSD bleed state (persists across rooms via persistent object)
global.clarity_timer       = 0;    // frames of PTSD suppression remaining
global.ptsd_flicker_count  = 0;    // lifetime enemy flicker sightings
global.total_deaths        = 0;    // lifetime death count
global.total_clarity       = 0;    // lifetime clarity pickups collected
global.play_seconds        = 0;    // in-session seconds played
play_second_tick           = 0;    // step counter for 1-second intervals
```

- [ ] **Step 2: Verify**

Open GameMaker IDE, run the game to Room1. In the debugger or by adding a temporary `show_debug_message(string(global.clarity_timer))` in obj_controller Step, confirm the variable exists without crash.

- [ ] **Step 3: Commit**

```
git add objects/obj_controller/Create_0.gml
git commit -m "feat: add PTSD globals and achievement counters to controller"
```

---

## Task 2: PTSD audio assets

**Files:**
- Create: `sounds/snd_ptsd_ring/snd_ptsd_ring.wav`
- Create: `sounds/snd_ptsd_ring/snd_ptsd_ring.yy`
- Create: `sounds/snd_ptsd_horn/snd_ptsd_horn.wav`
- Create: `sounds/snd_ptsd_horn/snd_ptsd_horn.yy`

- [ ] **Step 1: Create sound directories**

```powershell
New-Item -ItemType Directory -Force "C:\Users\avkov\GameMakerProjects\Foxhole-Dan\sounds\snd_ptsd_ring"
New-Item -ItemType Directory -Force "C:\Users\avkov\GameMakerProjects\Foxhole-Dan\sounds\snd_ptsd_horn"
```

- [ ] **Step 2: Generate snd_ptsd_ring.wav (phone-like 880 Hz ring, 1.8 s)**

```powershell
$ffmpeg = "C:\Users\avkov\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-8.1.1-full_build\bin\ffmpeg.exe"
& $ffmpeg -f lavfi -i "sine=frequency=880:duration=1.8" -af "afade=t=in:st=0:d=0.05,afade=t=out:st=1.6:d=0.2,volume=0.4" -ar 44100 -ac 1 -sample_fmt s16 -y "C:\Users\avkov\GameMakerProjects\Foxhole-Dan\sounds\snd_ptsd_ring\snd_ptsd_ring.wav"
```

- [ ] **Step 3: Generate snd_ptsd_horn.wav (low 220 Hz horn burst, 0.8 s)**

```powershell
$ffmpeg = "C:\Users\avkov\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-8.1.1-full_build\bin\ffmpeg.exe"
& $ffmpeg -f lavfi -i "sine=frequency=220:duration=0.8" -af "afade=t=in:st=0:d=0.05,afade=t=out:st=0.6:d=0.2,volume=0.55" -ar 44100 -ac 1 -sample_fmt s16 -y "C:\Users\avkov\GameMakerProjects\Foxhole-Dan\sounds\snd_ptsd_horn\snd_ptsd_horn.wav"
```

- [ ] **Step 4: Write snd_ptsd_ring.yy**

```json
{
  "$GMSound":"v2",
  "%Name":"snd_ptsd_ring",
  "audioGroupId":{
    "name":"audiogroup_default",
    "path":"audiogroups/audiogroup_default",
  },
  "bitDepth":1,
  "channelFormat":0,
  "compression":0,
  "compressionQuality":4,
  "conversionMode":0,
  "duration":0.0,
  "exportDir":"",
  "name":"snd_ptsd_ring",
  "parent":{
    "name":"Foxhole-Dan",
    "path":"Foxhole-Dan.yyp",
  },
  "preload":false,
  "resourceType":"GMSound",
  "resourceVersion":"2.0",
  "sampleRate":44100,
  "soundFile":"snd_ptsd_ring.wav",
  "volume":0.5,
}
```

- [ ] **Step 5: Write snd_ptsd_horn.yy**

```json
{
  "$GMSound":"v2",
  "%Name":"snd_ptsd_horn",
  "audioGroupId":{
    "name":"audiogroup_default",
    "path":"audiogroups/audiogroup_default",
  },
  "bitDepth":1,
  "channelFormat":0,
  "compression":0,
  "compressionQuality":4,
  "conversionMode":0,
  "duration":0.0,
  "exportDir":"",
  "name":"snd_ptsd_horn",
  "parent":{
    "name":"Foxhole-Dan",
    "path":"Foxhole-Dan.yyp",
  },
  "preload":false,
  "resourceType":"GMSound",
  "resourceVersion":"2.0",
  "sampleRate":44100,
  "soundFile":"snd_ptsd_horn.wav",
  "volume":0.5,
}
```

- [ ] **Step 6: Register sounds in Foxhole-Dan.yyp**

In `Foxhole-Dan.yyp`, inside the `"resources":[...]` array, add after the `snd_player_hurt` entry:

```json
    {"id":{"name":"snd_ptsd_horn","path":"sounds/snd_ptsd_horn/snd_ptsd_horn.yy",},},
    {"id":{"name":"snd_ptsd_ring","path":"sounds/snd_ptsd_ring/snd_ptsd_ring.yy",},},
```

- [ ] **Step 7: Verify**

Run the game. In obj_controller Create_0 temporarily add `audio_play_sound(snd_ptsd_ring, 10, false);` — confirm the ring tone plays without a compile error. Remove the test line.

- [ ] **Step 8: Commit**

```
git add sounds/snd_ptsd_ring/ sounds/snd_ptsd_horn/ Foxhole-Dan.yyp
git commit -m "feat: add PTSD audio intrusion sound assets"
```

---

## Task 3: Room1 PTSD bleed (obj_controller)

**Files:**
- Modify: `objects/obj_controller/Create_0.gml`
- Modify: `objects/obj_controller/Step_0.gml`
- Modify: `objects/obj_controller/Draw_64.gml`

- [ ] **Step 1: Add bleed state vars to obj_controller Create_0**

Append to the end of `Create_0.gml` (after the globals block added in Task 1):

```gml
ptsd_bleed_timer = irandom_range(3600, 7200);  // 60-120 sec before first intrusion
ptsd_text_active = 0;
ptsd_text_msg    = "";
```

- [ ] **Step 2: Add bleed logic to obj_controller Step_0**

Append to the end of `Step_0.gml`:

```gml
// === PTSD BLEED EFFECTS (Room1 only) ===
if (room == Room1 && global.game_state == 0) {
    if (global.clarity_timer > 0) {
        global.clarity_timer--;
    } else {
        // Countdown to next intrusion
        if (ptsd_bleed_timer > 0) {
            ptsd_bleed_timer--;
        } else {
            // Fire an intrusion
            ptsd_bleed_timer = irandom_range(3600, 7200);
            var _type = irandom(2);  // 0=ring, 1=horn, 2=text-only
            if (_type == 0) audio_play_sound(snd_ptsd_ring, 8, false);
            if (_type == 1) audio_play_sound(snd_ptsd_horn, 8, false);
            // Always show text fragment
            var _msgs = [
                "just getting milk",
                "kids are home at 4",
                "it's not real",
                "call back later",
                "the window was open",
                "just the neighbors"
            ];
            ptsd_text_msg    = _msgs[irandom(5)];
            ptsd_text_active = 90;
        }
    }
    // Playtime counter
    play_second_tick++;
    if (play_second_tick >= 60) {
        play_second_tick = 0;
        global.play_seconds++;
        if (global.play_seconds == 6000) steam_set_achievement("ach_playtime");
    }
}
```

- [ ] **Step 3: Add text fragment rendering to obj_controller Draw_64**

In `Draw_64.gml`, find the line `var gw = display_get_gui_width();` at the top. After the existing dead/win screen exit blocks (after all the `if (global.game_state == ...) { ... exit; }` blocks), add this block before any HUD drawing:

```gml
// === PTSD TEXT FRAGMENT ===
if (ptsd_text_active > 0) {
    var _fade = min(ptsd_text_active / 25.0, 1.0);
    if (ptsd_text_active < 35) _fade = ptsd_text_active / 35.0;
    draw_set_alpha(_fade * 0.52);
    draw_set_color(make_color_rgb(220, 210, 185));
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_set_font(-1);
    draw_text_transformed(44, gh - 24, ptsd_text_msg, 0.88, 0.88, 0);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
```

- [ ] **Step 4: Verify**

Run to Room1. Wait 60–120 seconds of in-game time. Confirm a faint text message appears at the bottom-left of the screen and fades. Confirm no crash.

- [ ] **Step 5: Commit**

```
git add objects/obj_controller/Create_0.gml objects/obj_controller/Step_0.gml objects/obj_controller/Draw_64.gml
git commit -m "feat: add PTSD bleed audio and text intrusions to Room1"
```

---

## Task 4: Room3 PTSD bleed (obj_controller3)

**Files:**
- Modify: `objects/obj_controller3/Step_0.gml`
- Modify: `objects/obj_controller3/Draw_64.gml`

- [ ] **Step 1: Add bleed state to obj_controller3 Create_0**

Append to the end of `objects/obj_controller3/Create_0.gml`:

```gml
ptsd_bleed_timer = irandom_range(2400, 4800);  // shorter interval — Room3 is intense
ptsd_text_active = 0;
ptsd_text_msg    = "";
```

- [ ] **Step 2: Add bleed logic to obj_controller3 Step_0**

Append to the end of `objects/obj_controller3/Step_0.gml`:

```gml
// === PTSD BLEED EFFECTS (Room3) ===
if (global.game_state == 0) {
    if (global.clarity_timer > 0) {
        global.clarity_timer--;
    } else {
        if (ptsd_bleed_timer > 0) {
            ptsd_bleed_timer--;
        } else {
            ptsd_bleed_timer = irandom_range(2400, 4800);
            var _type = irandom(2);
            if (_type == 0) audio_play_sound(snd_ptsd_ring, 8, false);
            if (_type == 1) audio_play_sound(snd_ptsd_horn, 8, false);
            var _msgs = [
                "just getting milk",
                "kids are home at 4",
                "it's not real",
                "call back later",
                "the window was open",
                "just the neighbors"
            ];
            ptsd_text_msg    = _msgs[irandom(5)];
            ptsd_text_active = 90;
        }
    }
}
```

- [ ] **Step 3: Add text rendering to obj_controller3 Draw_64**

Read the first 5 lines of `objects/obj_controller3/Draw_64.gml` to find where the GUI variables are declared. Append the following block near the top of Draw_64, after `var gw = display_get_gui_width(); var gh = display_get_gui_height();`:

```gml
// === PTSD TEXT FRAGMENT ===
if (ptsd_text_active > 0) {
    var _fade = min(ptsd_text_active / 25.0, 1.0);
    if (ptsd_text_active < 35) _fade = ptsd_text_active / 35.0;
    draw_set_alpha(_fade * 0.52);
    draw_set_color(make_color_rgb(220, 210, 185));
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_set_font(-1);
    draw_text_transformed(44, gh - 24, ptsd_text_msg, 0.88, 0.88, 0);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    ptsd_text_active--;
}
```

Also add `ptsd_text_active--;` decrement to the Step event for Room3 (the Step_0 bleed block above is missing this — the timer decrement should be in Step, not Draw). The Draw event should only read `ptsd_text_active`, not mutate it. Add `ptsd_text_active--;` inside the Step_0 bleed block, inside the `else` that fires the intrusion, after `ptsd_text_active = 90;`:

Actually, the timer should count down in Step, not Draw. In the Step_0 block added above, add a decrement after the bleed block:

```gml
// Decrement text active timer
if (ptsd_text_active > 0) ptsd_text_active--;
```

Do the same for obj_controller Step_0 as well (add the same line to the Room1 bleed block in Task 3 Step_0).

- [ ] **Step 4: Fix Room1 timer decrement**

In `objects/obj_controller/Step_0.gml`, inside the Room1 bleed block added in Task 3, add after the `play_second_tick` block:

```gml
    if (ptsd_text_active > 0) ptsd_text_active--;
```

- [ ] **Step 5: Verify**

Run to Room3. Wait ~40–80 seconds. Confirm text fragment appears at bottom-left. Confirm no crash during the climb.

- [ ] **Step 6: Commit**

```
git add objects/obj_controller3/Create_0.gml objects/obj_controller3/Step_0.gml objects/obj_controller3/Draw_64.gml objects/obj_controller/Step_0.gml
git commit -m "feat: add PTSD bleed intrusions to Room3, fix timer decrement"
```

---

## Task 5: Enemy flicker

**Files:**
- Modify: `objects/obj_enemy_soldier/Create_0.gml`
- Modify: `objects/obj_enemy_soldier/Draw_0.gml`

- [ ] **Step 1: Add flicker vars to obj_enemy_soldier Create_0**

Append to the end of `objects/obj_enemy_soldier/Create_0.gml`:

```gml
flicker_timer = 0;                          // frames remaining in current flicker
flicker_cd    = irandom_range(600, 1500);   // cooldown before next flicker (10-25 sec)
```

- [ ] **Step 2: Add flicker logic to obj_enemy_soldier Draw_0**

At the very top of `objects/obj_enemy_soldier/Draw_0.gml`, before `var bx = x;`, insert:

```gml
// === CIVILIAN FLICKER ===
if (flicker_cd > 0) {
    flicker_cd--;
} else if (flicker_timer <= 0 && global.clarity_timer <= 0) {
    flicker_timer = 3;
    flicker_cd    = irandom_range(600, 1500);
    global.ptsd_flicker_count++;
    if (global.ptsd_flicker_count == 10) steam_set_achievement("ach_flicker");
}
if (flicker_timer > 0) {
    flicker_timer--;
    // Draw civilian (unarmed, hands up) instead of soldier
    var bx = x;
    var by = y;
    var f  = image_xscale;
    // Body — plain civilian clothes (grey-blue)
    draw_set_color(make_color_rgb(108, 116, 132));
    draw_rectangle(bx - 6, by - 24, bx + 6, by, false);
    // Arms raised (surrendering)
    draw_set_color(make_color_rgb(108, 116, 132));
    draw_rectangle(bx - 14 * f, by - 24, bx - 6 * f, by - 18, false);
    draw_rectangle(bx + 6 * f,  by - 24, bx + 14 * f, by - 18, false);
    // Forearms up
    draw_rectangle(bx - 16 * f, by - 34, bx - 12 * f, by - 24, false);
    draw_rectangle(bx + 12 * f, by - 34, bx + 16 * f, by - 24, false);
    // Head
    draw_set_color(make_color_rgb(196, 154, 104));
    draw_rectangle(bx - 5, by - 34, bx + 5, by - 24, false);
    // No helmet — short hair
    draw_set_color(make_color_rgb(60, 46, 32));
    draw_rectangle(bx - 5, by - 36, bx + 5, by - 32, false);
    draw_set_color(c_white);
    exit;
}
```

- [ ] **Step 3: Verify**

Run to Room1. Watch enemies — every 10–25 seconds one will flicker to hands-up civilian for 3 frames. It's brief and unsettling. Confirm no crash, no visual glitch during normal combat.

- [ ] **Step 4: Commit**

```
git add objects/obj_enemy_soldier/Create_0.gml objects/obj_enemy_soldier/Draw_0.gml
git commit -m "feat: add civilian flicker to enemy soldiers"
```

---

## Task 6: Clarity suppression

**Files:**
- Modify: `objects/obj_clarity/Step_0.gml`

- [ ] **Step 1: Update obj_clarity Step_0 to set suppression timer and track count**

The current `obj_clarity/Step_0.gml` reads:

```gml
var p = instance_place(x, y, obj_dan);
if (p != noone) {
    p.ptsd_meter = max(p.ptsd_meter - 50, 0);
    instance_destroy();
}
bob_offset = random(2 * pi);
```

Replace with:

```gml
var p = instance_place(x, y, obj_dan);
if (p != noone) {
    p.ptsd_meter        = max(p.ptsd_meter - 50, 0);
    global.clarity_timer = 1800;   // 30 seconds suppression
    global.total_clarity++;
    if (global.total_clarity >= 4) steam_set_achievement("ach_clarity");
    instance_destroy();
}
bob_offset = random(2 * pi);
```

- [ ] **Step 2: Verify**

Run to Room1. Pick up the clarity object at x=1250. Confirm the PTSD bleed stops firing for ~30 seconds afterward (no text fragments, no audio). Pick up the second clarity at x=3100. Confirm the total_clarity counter reaches 2 without crash (full 4 requires Room3 pickups too).

- [ ] **Step 3: Commit**

```
git add objects/obj_clarity/Step_0.gml
git commit -m "feat: clarity pickup suppresses PTSD bleed for 30s, tracks achievement"
```

---

## Task 7: obj_controller6 — Create and Step

**Files:**
- Create: `objects/obj_controller6/obj_controller6.yy`
- Create: `objects/obj_controller6/Create_0.gml`
- Create: `objects/obj_controller6/Step_0.gml`

- [ ] **Step 1: Create obj_controller6 directory**

```powershell
New-Item -ItemType Directory -Force "C:\Users\avkov\GameMakerProjects\Foxhole-Dan\objects\obj_controller6"
```

- [ ] **Step 2: Write obj_controller6.yy**

```json
{
  "$GMObject":"v1",
  "%Name":"obj_controller6",
  "eventList":[
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":0,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":3,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":64,"eventType":8,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
  ],
  "managed":true,
  "name":"obj_controller6",
  "overriddenProperties":[],
  "parent":{
    "name":"Foxhole-Dan",
    "path":"Foxhole-Dan.yyp",
  },
  "parentObjectId":null,
  "persistent":false,
  "physicsAngularDamping":0.1,
  "physicsDensity":0.5,
  "physicsFriction":0.2,
  "physicsGroup":1,
  "physicsKinematic":false,
  "physicsLinearDamping":0.1,
  "physicsObject":false,
  "physicsRestitution":0.1,
  "physicsSensor":false,
  "physicsShape":1,
  "physicsShapePoints":[],
  "physicsStartAwake":true,
  "properties":[],
  "resourceType":"GMObject",
  "resourceVersion":"2.0",
  "solid":false,
  "spriteId":null,
  "spriteMaskId":null,
  "visible":true,
}
```

- [ ] **Step 3: Write obj_controller6/Create_0.gml**

```gml
audio_stop_all();
// Very distant gunfire — ambiguous (TV? real?)
distant_snd = audio_play_sound(snd_gunshot, 10, true);
audio_sound_gain(distant_snd, 0.04, 0);
audio_sound_pitch(distant_snd, 0.5);

depth   = -9999;
visible = true;

// Phase sequence:
//  0 = scene visible, silence (120 frames)
//  1 = text1 fading in: "He made it home."  (frames 120-210)
//  2 = text1 holds                           (frames 210-330)
//  3 = text2 fading in: "He always makes it home." (frames 330-420)
//  4 = window flicker                        (frames 420-423)
//  5 = hold, then fade to black              (frames 423-563)
//  6 = black screen, then Room0              (frames 563-683)
phase       = 0;
phase_timer = 0;

// Overlay fade (0=transparent, 1=opaque black)
fade_alpha  = 0.0;

// Window flicker state
window_flicker = false;

// Achievement fires once when entering phase 1
ach_fired = false;

camera_set_view_pos(view_camera[0], 0, 0);
```

- [ ] **Step 4: Write obj_controller6/Step_0.gml**

```gml
phase_timer++;

switch (phase) {
    case 0:
        if (phase_timer >= 120) { phase = 1; phase_timer = 0; }
        break;
    case 1:
        if (!ach_fired) {
            steam_set_achievement("ach_ending");
            ach_fired = true;
        }
        if (phase_timer >= 90) { phase = 2; phase_timer = 0; }
        break;
    case 2:
        if (phase_timer >= 120) { phase = 3; phase_timer = 0; }
        break;
    case 3:
        if (phase_timer >= 90) { phase = 4; phase_timer = 0; }
        break;
    case 4:
        window_flicker = (phase_timer <= 3);
        if (phase_timer >= 6) { phase = 5; phase_timer = 0; }
        break;
    case 5:
        // Fade to black over 80 frames, then hold
        if (phase_timer >= 60) {
            fade_alpha = min((phase_timer - 60) / 80.0, 1.0);
        }
        if (phase_timer >= 200) { phase = 6; phase_timer = 0; }
        break;
    case 6:
        if (phase_timer >= 120) {
            audio_stop_all();
            global.game_state = 0;
            room_goto(Room0);
        }
        break;
}
```

- [ ] **Step 5: Verify structure**

Confirm all three .gml files exist and have content. No compile check yet — that comes with Room6 registration.

- [ ] **Step 6: Commit**

```
git add objects/obj_controller6/
git commit -m "feat: add obj_controller6 with civilian ending phase sequence"
```

---

## Task 8: obj_controller6 — Draw_64 (kitchen scene)

**Files:**
- Create: `objects/obj_controller6/Draw_64.gml`

- [ ] **Step 1: Write the full kitchen scene draw code**

```gml
var gw = display_get_gui_width();
var gh = display_get_gui_height();

// =========================================================
// ROOM — dim interior
// =========================================================
draw_set_color(make_color_rgb(46, 40, 30));
draw_rectangle(0, 0, 1920, 768, false);

// Floor
draw_set_color(make_color_rgb(58, 48, 34));
draw_rectangle(0, 560, 1920, 768, false);
// Floor baseboard
draw_set_color(make_color_rgb(48, 40, 28));
draw_rectangle(0, 556, 1920, 566, false);

// Wall
draw_set_color(make_color_rgb(68, 60, 48));
draw_rectangle(0, 0, 1920, 560, false);

// =========================================================
// WINDOW (right side of room)
// =========================================================
var wx = 1280;
var wy = 160;
var ww = 240;
var wh = 200;

// Frame
draw_set_color(make_color_rgb(88, 78, 60));
draw_rectangle(wx - 8, wy - 8, wx + ww + 8, wy + wh + 8, false);

if (window_flicker) {
    // Combat flash — terrain silhouette for 3 frames
    draw_set_color(make_color_rgb(90, 64, 28));
    draw_rectangle(wx, wy, wx + ww, wy + wh, false);
    draw_set_color(make_color_rgb(18, 14, 8));
    draw_rectangle(wx,       wy + 130, wx + 60,  wy + wh, false);
    draw_rectangle(wx + 70,  wy + 110, wx + 150, wy + wh, false);
    draw_rectangle(wx + 160, wy + 125, wx + ww,  wy + wh, false);
} else {
    // Quiet daytime street
    draw_set_alpha(0.5);
    draw_set_color(make_color_rgb(160, 192, 218));
    draw_rectangle(wx, wy, wx + ww, wy + wh, false);
    draw_set_alpha(1);
    // Window dividers
    draw_set_color(make_color_rgb(78, 68, 52));
    draw_line_width(wx + ww/2, wy, wx + ww/2, wy + wh, 3);
    draw_line_width(wx, wy + wh/2, wx + ww, wy + wh/2, 3);
    // Street silhouette (house outline, tree)
    draw_set_alpha(0.35);
    draw_set_color(make_color_rgb(40, 56, 72));
    draw_rectangle(wx + 10,  wy + 110, wx + 90,  wy + wh, false);
    draw_rectangle(wx + 30,  wy + 80,  wx + 70,  wy + 110, false);
    draw_set_color(make_color_rgb(30, 52, 28));
    draw_circle(wx + 160, wy + 120, 28, false);
    draw_rectangle(wx + 155, wy + 140, wx + 165, wy + wh, false);
    draw_set_alpha(1);
}

// =========================================================
// TABLE
// =========================================================
var tx = 320;
var ty = 468;
// Table top (oak)
draw_set_color(make_color_rgb(96, 70, 40));
draw_rectangle(tx, ty, tx + 500, ty + 18, false);
// Table top highlight
draw_set_color(make_color_rgb(108, 80, 48));
draw_rectangle(tx + 4, ty + 2, tx + 496, ty + 7, false);
// Legs
draw_set_color(make_color_rgb(78, 56, 32));
draw_rectangle(tx + 18,  ty + 18, tx + 32,  ty + 160, false);
draw_rectangle(tx + 450, ty + 18, tx + 464, ty + 160, false);
// Shadow under table
draw_set_alpha(0.28);
draw_set_color(c_black);
draw_ellipse(tx + 60, ty + 160, tx + 440, ty + 172, false);
draw_set_alpha(1);

// =========================================================
// MUG
// =========================================================
var mx = 580;
var my = ty - 44;
// Mug body
draw_set_color(make_color_rgb(192, 174, 152));
draw_rectangle(mx - 13, my, mx + 13, my + 38, false);
// Coffee surface
draw_set_color(make_color_rgb(42, 24, 10));
draw_rectangle(mx - 11, my + 2, mx + 11, my + 10, false);
// Handle (C shape)
draw_set_color(make_color_rgb(174, 158, 136));
draw_circle(mx + 18, my + 20, 9, true);
draw_set_color(make_color_rgb(192, 174, 152));
draw_circle(mx + 18, my + 20, 5, true);
// Steam (only in phase 0-1 before weight sets in)
if (phase <= 1) {
    var _st = (current_time mod 90) / 90.0;
    draw_set_alpha(0.22);
    draw_set_color(make_color_rgb(230, 224, 215));
    draw_circle(mx - 2 + irandom(3), my - 10 - _st * 18, 4, false);
    draw_circle(mx + 4 + irandom(3), my - 6  - _st * 14, 3, false);
    draw_set_alpha(1);
}

// =========================================================
// DAN — civilian, slumped at table
// =========================================================
var dx = 520;
var dy = ty - 90;

// Chair back posts
draw_set_color(make_color_rgb(70, 54, 36));
draw_rectangle(dx - 20, dy - 20, dx - 16, dy + 55, false);
draw_rectangle(dx + 16, dy - 20, dx + 20, dy + 55, false);
draw_rectangle(dx - 20, dy - 21, dx + 20, dy - 17, false);
draw_rectangle(dx - 20, dy - 5,  dx + 20, dy - 1,  false);

// Body — plain civilian shirt (washed-out blue-grey, no gear)
draw_set_color(make_color_rgb(94, 106, 118));
draw_rectangle(dx - 15, dy, dx + 15, dy + 48, false);
// Slumped shoulders — trapezoid shape
draw_set_color(make_color_rgb(102, 114, 126));
draw_rectangle(dx - 18, dy - 12, dx + 18, dy + 4, false);
// Shoulder highlight
draw_set_color(make_color_rgb(112, 124, 136));
draw_line(dx - 17, dy - 11, dx + 17, dy - 11);

// Arms on table (reaching forward to mug)
draw_set_color(make_color_rgb(94, 106, 118));
draw_rectangle(dx - 14, dy + 8, dx + 60, dy + 22, false);

// Right hand wrapped around mug
draw_set_color(make_color_rgb(188, 148, 100));
draw_circle(mx - 13, my + 22, 7, false);
// Fingers
draw_set_color(make_color_rgb(178, 138, 92));
draw_line(mx - 18, my + 17, mx - 21, my + 13);
draw_line(mx - 18, my + 22, mx - 22, my + 20);
draw_line(mx - 17, my + 27, mx - 20, my + 30);

// Head (facing down-left, looking at mug — not at the player)
draw_set_color(make_color_rgb(188, 148, 100));
draw_rectangle(dx - 9, dy - 26, dx + 9, dy - 2, false);
// Jawline shadow
draw_set_color(make_color_rgb(158, 118, 76));
draw_rectangle(dx - 8, dy - 6, dx + 8, dy - 2, false);
// Eyes — downcast
draw_set_color(make_color_rgb(38, 34, 28));
draw_rectangle(dx - 5, dy - 16, dx - 3, dy - 13, false);
draw_rectangle(dx + 2, dy - 16, dx + 4, dy - 13, false);
// Stubble (no shave — not a soldier today, just a man who forgot)
draw_set_color(make_color_rgb(148, 112, 76));
draw_rectangle(dx - 7, dy - 8, dx + 7, dy - 4, false);
// Hair — short, civilian cut, no helmet
draw_set_color(make_color_rgb(54, 42, 28));
draw_rectangle(dx - 9, dy - 28, dx + 9, dy - 22, false);
draw_rectangle(dx - 10, dy - 26, dx - 8, dy - 14, false);

// =========================================================
// TEXT OVERLAY
// =========================================================
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(-1);

// "He made it home." — appears in phase 1-5
if (phase >= 1 && phase <= 5) {
    var _a1 = 0;
    if (phase == 1) _a1 = min(phase_timer / 60.0, 1.0);
    else if (phase >= 2) _a1 = 1.0;
    if (phase == 5 && phase_timer > 60) _a1 = max(1.0 - (phase_timer - 60) / 80.0, 0);
    draw_set_alpha(_a1 * 0.88);
    draw_set_color(make_color_rgb(228, 218, 198));
    draw_text_transformed(gw / 2, gh / 2 - 28, "He made it home.", 1.1, 1.1, 0);
    draw_set_alpha(1);
}

// "He always makes it home." — appears in phase 3-5
if (phase >= 3 && phase <= 5) {
    var _a2 = 0;
    if (phase == 3) _a2 = min(phase_timer / 60.0, 1.0);
    else if (phase >= 4) _a2 = 1.0;
    if (phase == 5 && phase_timer > 60) _a2 = max(1.0 - (phase_timer - 60) / 80.0, 0);
    draw_set_alpha(_a2 * 0.72);
    draw_set_color(make_color_rgb(190, 182, 168));
    draw_text_transformed(gw / 2, gh / 2 + 24, "He always makes it home.", 0.95, 0.95, 0);
    draw_set_alpha(1);
}

// =========================================================
// FADE OVERLAY
// =========================================================
if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
```

- [ ] **Step 2: Verify**

After Room6 is registered (Task 9), run to Room6 (temporarily add `room_goto(Room6)` in Room0 creation code to test). Confirm the kitchen scene draws, the text fades in sequence, the window flickers once at ~7 seconds, then fades to black and returns to Room0.

- [ ] **Step 3: Commit**

```
git add objects/obj_controller6/Draw_64.gml
git commit -m "feat: civilian kitchen ending scene draw code"
```

---

## Task 9: Room6 and yyp registration

**Files:**
- Create: `rooms/Room6/Room6.yy`
- Create: `rooms/Room6/RoomCreationCode.gml`
- Modify: `Foxhole-Dan.yyp`

- [ ] **Step 1: Create Room6 directory**

```powershell
New-Item -ItemType Directory -Force "C:\Users\avkov\GameMakerProjects\Foxhole-Dan\rooms\Room6"
```

- [ ] **Step 2: Write Room6.yy**

```json
{
  "$GMRoom":"v1",
  "%Name":"Room6",
  "creationCodeFile":"rooms/Room6/RoomCreationCode.gml",
  "inheritCode":false,
  "inheritCreationOrder":false,
  "inheritLayers":false,
  "instanceCreationOrder":[],
  "isDnd":false,
  "layers":[
    {"$GMRInstanceLayer":"","%Name":"Instances","depth":0,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[],"layers":[],"name":"Instances","properties":[],"resourceType":"GMRInstanceLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
    {"$GMRBackgroundLayer":"","%Name":"Background","animationFPS":15.0,"animationSpeedType":0,"colour":0,"depth":100,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"hspeed":0.0,"htiled":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"name":"Background","properties":[],"resourceType":"GMRBackgroundLayer","resourceVersion":"2.0","spriteId":null,"stretch":false,"userdefinedAnimFPS":false,"userdefinedDepth":false,"visible":true,"vspeed":0.0,"vtiled":false,"x":0,"y":0,},
  ],
  "name":"Room6",
  "parent":{
    "name":"Foxhole-Dan",
    "path":"Foxhole-Dan.yyp",
  },
  "parentRoom":null,
  "physicsSettings":{
    "inheritPhysicsSettings":false,
    "PhysicsWorld":false,
    "PhysicsWorldGravityX":0.0,
    "PhysicsWorldGravityY":10.0,
    "PhysicsWorldPixToMetres":0.1,
  },
  "resourceType":"GMRoom",
  "resourceVersion":"2.0",
  "roomSettings":{
    "Height":768,
    "inheritRoomSettings":false,
    "persistent":false,
    "Width":1920,
  },
  "sequenceId":null,
  "views":[
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":true,"vspeed":-1,"wport":1920,"wview":1920,"xport":0,"xview":0,"yport":0,"yview":0,},
  ],
  "viewSettings":{
    "clearDisplayBuffer":true,
    "clearViewBackground":true,
    "enableViews":true,
    "inheritViewSettings":false,
  },
  "volume":1.0,
}
```

- [ ] **Step 3: Write Room6/RoomCreationCode.gml**

```gml
instance_create_layer(0, 0, "Instances", obj_controller6);
```

- [ ] **Step 4: Register in Foxhole-Dan.yyp**

In `Foxhole-Dan.yyp`, inside `"resources":[...]`, add after the `Room5` entry:

```json
    {"id":{"name":"Room6","path":"rooms/Room6/Room6.yy",},},
```

Also add after the `obj_controller5` entry:

```json
    {"id":{"name":"obj_controller6","path":"objects/obj_controller6/obj_controller6.yy",},},
```

In `"RoomOrderNodes":[...]`, add after the Room5 entry:

```json
    {"roomId":{"name":"Room6","path":"rooms/Room6/Room6.yy",},},
```

- [ ] **Step 5: Verify**

Open GameMaker IDE. Confirm Room6 and obj_controller6 appear in the asset tree. Temporarily edit Room0's RoomCreationCode to add `room_goto(Room6);` as the first line. Run — confirm the kitchen scene appears, text fades in, and after ~15 seconds it returns to Room0 (the title screen). Remove the test line from Room0.

- [ ] **Step 6: Commit**

```
git add rooms/Room6/ Foxhole-Dan.yyp
git commit -m "feat: add Room6 civilian ending room and register all new assets in yyp"
```

---

## Task 10: Room5 → Room6 transition

**Files:**
- Modify: `objects/obj_controller5/Step_0.gml`

- [ ] **Step 1: Redirect win path from Room0 to Room6**

In `objects/obj_controller5/Step_0.gml`, find the PHASE 3 win block. It contains:

```gml
        global.game_state = 0;
        room_goto(Room0);
```

Replace both occurrences with:

```gml
        global.game_state = 0;
        room_goto(Room6);
```

There are two `room_goto(Room0)` calls in this file — one early (Reyes dead) and one at end of narrative slides. Both should redirect to Room6.

- [ ] **Step 2: Verify**

Complete Room5 (or temporarily set wave count to 1 in Create_0 for a quick test). Confirm that after the narrative slides finish, the game transitions to Room6's kitchen scene instead of the title screen.

- [ ] **Step 3: Commit**

```
git add objects/obj_controller5/Step_0.gml
git commit -m "feat: redirect Room5 win to Room6 civilian ending"
```

---

## Task 11: Achievement triggers

**Files:**
- Modify: `objects/obj_cutscene/Step_0.gml`
- Modify: `objects/obj_dan/Step_0.gml`
- Modify: `objects/obj_dan_vehicle/Step_0.gml`
- Modify: `objects/obj_controller3/Step_0.gml`
- Modify: `objects/obj_controller4/Step_0.gml`
- Modify: `objects/obj_controller5/Step_0.gml`

- [ ] **Step 1: ach_room1 — fire in obj_cutscene before room_goto(Room2)**

In `objects/obj_cutscene/Step_0.gml`, find the line `room_goto(Room2);`. Directly before it, insert:

```gml
steam_set_achievement("ach_room1");
```

- [ ] **Step 2: ach_deaths — track in obj_dan Step_0**

In `objects/obj_dan/Step_0.gml`, find the block where `hp <= 0` triggers death (the section that sets `global.game_state = 2`). Directly before `global.game_state = 2;`, insert:

```gml
global.total_deaths++;
if (global.total_deaths == 25) steam_set_achievement("ach_deaths");
```

- [ ] **Step 3: ach_room2 — fire in obj_dan_vehicle at win condition**

In `objects/obj_dan_vehicle/Step_0.gml`, find:

```gml
if (x >= 11600 && global.game_state == 0) {
    global.game_state = 3;
    instance_create_layer(0, 0, "Instances", obj_cutscene2);
}
```

Replace with:

```gml
if (x >= 11600 && global.game_state == 0) {
    global.game_state = 3;
    steam_set_achievement("ach_room2");
    instance_create_layer(0, 0, "Instances", obj_cutscene2);
}
```

- [ ] **Step 4: ach_room3 — fire in obj_controller3 before room_goto(Room4)**

In `objects/obj_controller3/Step_0.gml`, find the line `room_goto(Room4);`. Directly before it, insert:

```gml
steam_set_achievement("ach_room3");
```

- [ ] **Step 5: ach_room4 — fire in obj_controller4 before room_goto(Room5)**

In `objects/obj_controller4/Step_0.gml`, find the line `room_goto(Room5);`. Directly before it, insert:

```gml
steam_set_achievement("ach_room4");
```

- [ ] **Step 6: ach_room5 — fire in obj_controller5 when Reyes dies**

In `objects/obj_controller5/Step_0.gml`, find the comment `// Reyes dead — we win` and the `global.game_state = 0;` line directly after it. Insert before that line:

```gml
steam_set_achievement("ach_room5");
```

- [ ] **Step 7: Verify**

Run through Room1 and die once. Confirm `global.total_deaths` increments (add temporary `show_debug_message(string(global.total_deaths))` in obj_dan Step if needed). Remove debug line. Test the Room2 win by reaching x=11600 in the vehicle.

- [ ] **Step 8: Commit**

```
git add objects/obj_cutscene/Step_0.gml objects/obj_dan/Step_0.gml objects/obj_dan_vehicle/Step_0.gml objects/obj_controller3/Step_0.gml objects/obj_controller4/Step_0.gml objects/obj_controller5/Step_0.gml
git commit -m "feat: add Steam achievement triggers at all room completions and death counter"
```

---

## Task 12: Steam store page document

**Files:**
- Create: `docs/steam-store-page.md`

- [ ] **Step 1: Write store page document**

```markdown
# Foxhole Dan — Steam Store Page

## Short Description (160 chars max)
A decorated veteran fights his way through war. Or through something that looks like war.

## Long Description
Dan came home. Decorated. Respected. He built a life — family, a routine, a reason to keep going.

But the war didn't stay over there.

FOXHOLE DAN is a side-scrolling action game about a man who can't tell the difference between
what's real and what his mind is still fighting. You'll drive through contested roads, climb bombed
buildings, defuse devices under pressure, and hold a position against everything that comes at you.

You'll also wonder, sometimes, whether any of it is happening.

**Features:**
- 6-stage campaign from street combat to tower defense
- Difficulty scaling from accessible to punishing
- 10 Steam achievements — some of them are just for being human
- An ending you won't fully understand until later

*Mature themes. War. PTSD. Not for children.*

*Music by Kevin MacLeod (incompetech.com). Licensed under Creative Commons: By Attribution 3.0.*

## Tags (submit in this order — first 5 carry most weight)
1. Psychological Horror
2. Story Rich
3. Action
4. Indie
5. Shoot 'Em Up
6. Singleplayer
7. Dark
8. Atmospheric
9. 2D
10. Military

## Capsule Art Brief (for artist)
- Split composition: Dan silhouetted, vertical cut down the centre
- LEFT half: combat gear, M1 helmet, rifle at side — muted olive/grey palette
- RIGHT half: civilian clothes, plain shirt, hand around a coffee mug — warmer, dimmer
- Background: dark gradient — no explosions, no fire, no action
- The image asks a question. It does not show violence.
- No title text on capsule (Steam overlays the game name)
- Sizes needed: 460×215 (header capsule), 231×87 (small capsule), 616×353 (main capsule)

## Trailer Script (target: 55-60 seconds)

**0:00–0:10** — Black screen. Ambient civilian sound: distant traffic, birds.
A voice (warm, quiet): *"When'd you get back?"*
A beat. Then: a single gunshot, far off.
Cut to black.

**0:10–0:18** — Room1 gameplay. Dan moves through rubble. Enemies approach.
No music yet — just ambient combat sound.

**0:18–0:26** — Vehicle run (Room2). The jeep drives hard. Enemy vehicles. Bombers overhead.
Music begins: low, building.

**0:26–0:32** — Enemy soldier flickers to civilian (hands up) for 1 second. Cut away.
The player character keeps shooting.

**0:32–0:40** — The Climb (Room3). Dan scrambling upward. Text fragment fades in at screen edge:
*"kids are home at 4"*

**0:40–0:48** — Room4 bomb defusal, Room5 tower defense. Fast cuts. Music peaks.

**0:48–0:54** — The kitchen table. Dan. The mug. The quiet window.
Music drops to nothing.
Text fades in: *"He made it home."*

**0:54–1:00** — *"He always makes it home."*
Title card: **FOXHOLE DAN**
No tagline. Fade to black.

## Steam Next Fest Demo Scope
- Include: Room0 (title/controls) + Room1 (foot combat) + Room2 (vehicle run)
- End of demo: vehicle reaches win position → hard cut to black + "Coming Soon on Steam" card
- Do NOT include Room3–Room6 — leave the psychological layer and ending as discovery
- Demo build should include PTSD bleed effects (audio intrusions, text fragments, enemy flicker)
  so players experience the hook before they buy

## Kevin MacLeod Attribution (required — place in credits and store page)
"Music by Kevin MacLeod (incompetech.com)
Licensed under Creative Commons: By Attribution 3.0
http://creativecommons.org/licenses/by/3.0/"

Tracks used:
- Ossuary 5 - Rest (title screen)
- Crossing the Chasm (Room1)
- Militaire Electronic (Room2)
- Dark Walk (Room3)
- Five Armies (Room4)
- Future Gladiator (Room5)
- Lamentation (cutscenes)
```

- [ ] **Step 2: Commit**

```
git add docs/steam-store-page.md
git commit -m "docs: Steam store page copy, tags, trailer script, capsule brief"
```

---

## Achievement ID Reference

| Steam ID | Display Name | Trigger Location |
|---|---|---|
| `ach_room1` | Still Standing | `obj_cutscene/Step_0.gml` before `room_goto(Room2)` |
| `ach_room2` | The Long Road | `obj_dan_vehicle/Step_0.gml` at x >= 11600 |
| `ach_room3` | The Climb | `obj_controller3/Step_0.gml` before `room_goto(Room4)` |
| `ach_room4` | Defused | `obj_controller4/Step_0.gml` before `room_goto(Room5)` |
| `ach_room5` | Hold the Line | `obj_controller5/Step_0.gml` when Reyes dies |
| `ach_ending` | He Made It Home | `obj_controller6/Step_0.gml` phase 1 entry |
| `ach_deaths` | Ghost | `obj_dan/Step_0.gml` at total_deaths == 25 |
| `ach_clarity` | It's Not Real | `obj_clarity/Step_0.gml` at total_clarity >= 4 |
| `ach_playtime` | 100 Days | `obj_controller/Step_0.gml` at play_seconds == 6000 |
| `ach_flicker` | I See Them Too | `obj_enemy_soldier/Draw_0.gml` at ptsd_flicker_count == 10 |
