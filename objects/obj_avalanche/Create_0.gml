// === AVALANCHE — a sweeping snow band descending over part of the width ===
// Spawned by obj_controller13, which sets band_x / band_w after creation.
// Phase 1: warning rumble (telegraph). Phase 2: the snow sheet sweeps down
// through the camera view. Dan takes damage if caught in it and NOT sheltered
// under a rock outcrop (an obj_platform directly overhead within ~120px).

band_x = 0;                 // left edge of the band (controller overrides)
band_w = room_width * 0.5;  // width covered      (controller overrides)
band_h = 260;               // vertical thickness of the snow sheet

active     = false;         // false = telegraph phase
warn_timer = 110;           // ~1.8s of rumble before it hits
band_y     = -1000;         // set when the sweep starts
sweep_spd  = 13;

// Sweep damage per hit-tick by difficulty:  Easy  Normal  Hard  Brutal
var _d   = variable_global_exists("difficulty") ? global.difficulty : 1;
var _tab = [10, 14, 18, 22];
dmg = _tab[clamp(_d, 0, 3)];

// Low rumble at the telegraph
var _s = audio_play_sound(snd_explosion, 4, false);
audio_sound_gain(_s, 0.30, 0);
global.shake_mag = max(global.shake_mag, 2.0);
