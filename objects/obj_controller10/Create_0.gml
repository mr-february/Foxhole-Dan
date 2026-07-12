// === obj_controller10 — DOWNRIVER (swim) controller. Owns the camera. ===
audio_stop_all();
audio_play_sound(snd_music_room3, 100, true);

global.game_state = 0;
depth    = -9999;
visible  = true;
level_no = 7;

cam_x    = 0;
exit_x   = 4600;
win_timer = 0;

if (!variable_global_exists("combo_timer")) scr_init_run();
global.shake_mag = 0;
global.flash_timer = 0;
