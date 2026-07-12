audio_stop_all();
audio_play_sound(snd_music_room3, 100, true);
global.game_state = 0;
depth   = -9999;
visible = true;              // step last every frame — camera override runs after Dan's
cam_y = 2466;  // Dan.y(2888) - cam_h*0.55(422), keeps Dan at 55% from top
camera_set_view_pos(view_camera[0], 0, 2466);  // apply immediately — don't wait for first Step
transition_timer = 0;  // counts up after Dan reaches roof, then goes to Room4
danger_y   = room_height + 300;  // rising artillery floor — starts below the room
danger_rise = 0.35;              // px per step, accelerates over time
ptsd_bleed_timer = irandom_range(2400, 4800);  // shorter interval — Room3 is intense
ptsd_text_active = 0;
ptsd_text_msg    = "";
global.streak       = 0;
global.streak_timer = 0;
room_fade  = 45;
card_timer = 190;
ptsd_panic_played = false;
