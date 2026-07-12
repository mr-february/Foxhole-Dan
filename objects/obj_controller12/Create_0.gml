// === LEVEL 9: INTERROGATION — Project FOXHOLE, Site 9 ===
// Resist minigame in the Room4 bomb-defuse engine style.
// No platforming: a phase state machine + timed resist challenges.

audio_stop_all();
audio_play_sound(snd_music_cutscene, 100, true);
depth   = -9999;
visible = true;

global.game_state = 0;

var _d = variable_global_exists("difficulty") ? global.difficulty : 1;

// Story branch flag read by later cutscenes / the ending.
// Default: Dan resists. Breaking under the challenges flips it to false.
global.interro_resisted = true;

// phase: 0 = intro slides, 1 = interrogation (challenge machine), 2 = outcome slides
phase = 0;

// === INTRO SLIDES (phase 0) ===
intro_slide   = 0;
intro_slides  = 4;      // slides 0..3, SPACE advances
slide_fade_in = 0;      // frames since current slide started (fade system)

// === RESOLVE (Dan's grip on himself, 0-100) ===
resolve           = 100;
resolve_flash     = 0;      // red flash frames when resolve takes a hit
challenges_failed = 0;
challenges_passed = 0;

// === CHALLENGE SEQUENCE (phase 1) ===
// type: 0 = MASH resist, 1 = HOLD steady (needle), 2 = DEFLECT prompts
ch_types = [0, 2, 1, 0, 2];
ch_count = array_length(ch_types);
ch_index = 0;

// ch_state: 0 = Handler's question card, 1 = challenge active, 2 = result card
ch_state       = 0;
ch_state_timer = 170;   // frames the question card stays up before the challenge
ch_timer       = 0;     // frames left in the active challenge
ch_time_now    = 1;     // full length of the active challenge (for the timer bar)
ch_result      = 0;     // 1 = held out, -1 = slipped (result card)

// Base challenge time limit per difficulty (frames). Later rounds get shorter.
//                Easy    Normal  Hard   Brutal
var _time_tab = [12 * 60, 10 * 60, 8 * 60, 7 * 60];
ch_time_base = _time_tab[_d];

// --- MASH resist: mash SPACE/A to fill the resolve bar; the drip drags it down ---
mash_progress = 0;
mash_gain     = 0.045;
var _decay_tab = [0.0035, 0.0050, 0.0065, 0.0080];
mash_decay = _decay_tab[_d];

// --- HOLD steady: hold J/LB against the drug's pull; keep the needle in the zone ---
needle_pos  = 0;        // -1 .. +1 across the gauge
needle_t    = 0;        // waveform clock
zone_half   = 0.30;     // green zone is |needle_pos| <= zone_half
zone_time   = 0;        // accumulated frames inside the zone
var _zone_need_tab = [3 * 60, 4 * 60, 5 * 60, 6 * 60];
zone_need = _zone_need_tab[_d];
var _push_tab = [0.010, 0.013, 0.016, 0.019];
needle_push = _push_tab[_d];    // drug pressure pushing the needle right
hold_force  = 0.024;            // holding J pulls it back left — pulse it, don't pin it

// --- DEFLECT: press LEFT/RIGHT matching the prompt to turn leading questions aside ---
def_need         = 6;               // correct deflections to pass (raised in round 2)
def_need_now     = def_need;
def_done         = 0;
def_miss         = 0;
def_maxmiss      = 3;
def_current      = irandom(1);      // 0 = LEFT, 1 = RIGHT
var _def_win_tab = [110, 90, 70, 55];
def_window       = _def_win_tab[_d];  // frames allowed per prompt
def_window_now   = def_window;
def_prompt_timer = 0;
def_flash        = 0;               // +frames = green (hit), -frames = red (miss)

// The Handler's line for each round (drawn on the question card)
handler_q = [
    "\"Let's start simple, Private. What happened at the river?\"",
    "\"Sergeant Hayes carried you two miles. Who did you leave behind?\"",
    "\"The needle doesn't lie, Dan. Hold very still for me.\"",
    "\"44-7821. You were never discharged. You were deployed.\"",
    "\"Last chance. Say what you saw at the river. Say it.\"",
];

// === OUTCOME SLIDES (phase 2) ===
end_timer       = 0;
narrative_slide = 0;    // 0 = verdict card, 1..5 = story, 6 = final (auto-goto Room4)
outcome_slides  = 7;
