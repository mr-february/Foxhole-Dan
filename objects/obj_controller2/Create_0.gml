audio_stop_all();
global.music_inst = audio_play_sound(snd_music_room2, 100, true);
global.game_state = 0;  // 0=playing  1=win  2=dead  4=paused
depth = -9998;
if (!variable_global_exists("streak"))       global.streak       = 0;
if (!variable_global_exists("streak_timer")) global.streak_timer = 0;
global.streak       = 0;
global.streak_timer = 0;
room_fade  = 45;
card_timer = 190;

// Pause state
pause_sel          = 0;
pause_settings     = false;
pause_settings_sel = 0;

// (touch input handled via device_mouse_x_to_gui in vehicle's Step_0 and controller2 Step_0)
