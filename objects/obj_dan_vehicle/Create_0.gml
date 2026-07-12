engine_snd   = audio_play_sound(snd_engine, 10, true);
audio_sound_gain(engine_snd, 0.35, 0);
eng_pitch    = 1.0;
brake_snd_cd = 0;
shoot_flash  = 0;
move_spd     = 5;
vspd         = 0;
on_ground    = false;
grav         = 0.6;
jump_spd     = -13;
facing       = 1;

// Difficulty scaling
var _d = variable_global_exists("difficulty") ? global.difficulty : 1;
//                  Easy  Normal  Hard  Brutal
var _hp_tab  = [200,  140,   100,   70];
var _obs_tab = [10,    18,    25,   35];   // obstacle hit damage
var _bul_tab = [8,     14,    20,   28];   // enemy bullet damage
hp           = _hp_tab[_d];
max_hp       = _hp_tab[_d];
obs_dmg      = _obs_tab[_d];
bullet_dmg   = _bul_tab[_d];
i_frames     = 0;

ammo         = 40;
max_ammo     = 40;
shoot_timer  = 0;
shoot_delay  = 14;
reload_timer = 0;

wheel_spin   = 0;
depth        = -100;

bomb_count   = 3;
bomb_cd      = 0;

aim_dir      = 0;

// Safety defaults if earlier rooms (and obj_controller) were skipped in dev
if (!variable_global_exists("combo_count"))    global.combo_count    = 0;
if (!variable_global_exists("combo_mult"))     global.combo_mult     = 1;
if (!variable_global_exists("combo_timer"))    global.combo_timer    = 0;
if (!variable_global_exists("run_kills"))      global.run_kills      = 0;
if (!variable_global_exists("run_time"))       global.run_time       = 0;
if (!variable_global_exists("run_hits_taken")) global.run_hits_taken = 0;
