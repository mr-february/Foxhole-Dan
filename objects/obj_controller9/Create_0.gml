// === obj_controller9 — DUST-OFF (on-rails chopper) controller ===
audio_stop_all();
audio_play_sound(snd_music_room2, 100, true);

global.game_state = 0;
depth    = -9999;
visible  = true;
level_no = 6;

var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

scroll        = 0;
scroll_speed  = 1.4;
scroll_target = 6000;           // distance to the LZ
ground_y      = 640;

spawn_cd     = [80, 66, 54, 44][_d];
spawn_timer  = 90;
win_timer    = 0;

if (!variable_global_exists("combo_timer")) scr_init_run();
global.shake_mag = 0;
global.flash_timer = 0;
