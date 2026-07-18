// === obj_dan_chopper — door gunner on an on-rails extraction (Dust-Off) ===
var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);
chopper_hp     = [200, 160, 120, 90][_d];
chopper_max_hp = chopper_hp;
i_frames       = 0;             // brief invuln after a hit (shared feel)

aim_x = x + 300;
aim_y = 300;

fire_cd    = 6;                 // door gun is rapid
fire_timer = 0;

rotor = 0;
engine_snd = audio_play_sound(snd_engine, 10, true);

if (!variable_global_exists("combo_timer")) scr_init_run();
