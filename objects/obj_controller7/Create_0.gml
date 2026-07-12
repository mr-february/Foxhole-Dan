// === obj_controller7 — COLD SWEAT (stealth) level controller ===
audio_stop_all();
audio_play_sound(snd_music_room2, 100, true);

global.game_state = 0;
depth    = -9999;
visible  = true;
level_no = 2;

global.stealth_alert = 0;   // 0..100 shared alarm level
reinforced   = false;       // reinforcement wave fires once at full alert
win_timer    = 0;
exit_x       = 4600;        // reach here to escape

// Defensive global init if a room was entered directly during dev.
if (!variable_global_exists("difficulty"))  global.difficulty  = 1;
if (!variable_global_exists("combo_timer")) scr_init_run();
if (!variable_global_exists("clarity_timer")) global.clarity_timer = 0;
global.shake_mag   = 0;
global.flash_timer = 0;
