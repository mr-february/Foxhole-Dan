// === THE MOUNTAIN (Level 11) — hazard-dodge vertical climb controller ===
audio_stop_all();
audio_play_sound(snd_music_room3, 100, true);   // climb track (reused for the mountain)
global.game_state = 0;
depth    = -9999;
visible  = true;             // step last every frame — camera override runs after Dan's
level_no = 11;               // display level number for the HUD

cam_y = 2466;  // Dan.y(2888) - cam_h*0.55(422), keeps Dan at 55% from top
camera_set_view_pos(view_camera[0], 0, 2466);  // apply immediately — don't wait for first Step

climb_top_y      = 280;   // summit threshold — Dan wins when p.y < this
transition_timer = 0;     // counts up after the summit, then goes to Room5 (The Siege)

// === HAZARD SPAWN TIMERS ===
// Intensity scales with altitude (climb_pct) and global.difficulty.
//                     Easy  Normal  Hard  Brutal
var _d          = variable_global_exists("difficulty") ? global.difficulty : 1;
var _rate_tab   = [1.45, 1.0, 0.80, 0.62];       // multiplier on spawn delays
hazard_rate     = _rate_tab[clamp(_d, 0, 3)];

boulder_timer   = round(300 * hazard_rate);      // first rock ~5s in
avalanche_timer = round(1050 * hazard_rate);     // first slide ~17s in
climb_pct       = 0;                             // updated each Step, read by Draw_64
