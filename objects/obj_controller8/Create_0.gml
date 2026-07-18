// === obj_controller8 — OVERWATCH (sniper) level controller ===
audio_stop_all();
audio_play_sound(snd_music_room1, 100, true);

global.game_state = 0;
depth    = -9999;
visible  = true;
level_no = 4;

var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

// Wave system: number of enemies per wave, scaled by difficulty.
//            Easy      Normal     Hard        Brutal
var _waves = [[4,6,8],  [6,8,11],  [8,11,14],  [10,14,18]];
wave_counts = _waves[_d];
total_waves = array_length(wave_counts);
wave_index  = 0;
to_spawn    = 0;                  // remaining to spawn in the current wave
spawn_timer = 60;
wave_gap    = 0;                  // pause between waves
phase       = 0;                  // 0=spawning wave, 1=clearing, 2=gap, 3=won
win_timer   = 0;
street_y    = 660;

if (!variable_global_exists("combo_timer")) scr_init_run();
global.shake_mag = 0;
global.flash_timer = 0;

scope_surf = -1;   // scope lens render target — created lazily in Draw_64, freed in Destroy_0
