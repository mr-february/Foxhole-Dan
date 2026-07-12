move_spd   = 4;
jump_spd   = -15;
grav       = 0.6;
vspd       = 0;
hspd       = 0;
on_ground  = false;
facing     = 1;
crouching  = false;

aim_dir      = 0;
shoot_timer  = 0;
shoot_delay  = 12;
recoil       = 0;

hp       = 100;
max_hp   = 100;
i_frames = 0;

ammo         = 60;
max_ammo     = 60;
reload_timer = 0;

ptsd_meter   = 0;
ptsd_max     = 100;
ptsd_cooldown = 0;

flashback_active   = false;
flashback_timer    = 0;
flashback_duration = 300;
flashback_cooldown = 0;

hook_inst = noone;
rope_len  = 0;

roll_timer = 0;
roll_cd    = 0;
roll_dur   = 16;

grenade_count = 3;
grenade_cd    = 0;

// Safety defaults if Room1 (and obj_controller) was skipped in dev
if (!variable_global_exists("total_deaths"))       global.total_deaths       = 0;
if (!variable_global_exists("clarity_timer"))      global.clarity_timer      = 0;
if (!variable_global_exists("ptsd_flicker_count")) global.ptsd_flicker_count = 0;
if (!variable_global_exists("total_clarity"))      global.total_clarity      = 0;
if (!variable_global_exists("play_seconds"))       global.play_seconds       = 0;
if (!variable_global_exists("combo_count"))        global.combo_count        = 0;
if (!variable_global_exists("combo_mult"))         global.combo_mult         = 1;
if (!variable_global_exists("combo_timer"))        global.combo_timer        = 0;
if (!variable_global_exists("run_kills"))          global.run_kills          = 0;
if (!variable_global_exists("run_time"))           global.run_time           = 0;
if (!variable_global_exists("run_hits_taken"))     global.run_hits_taken     = 0;
if (!variable_global_exists("streak"))             global.streak             = 0;
if (!variable_global_exists("streak_timer"))       global.streak_timer       = 0;
if (!variable_global_exists("pickup_flash_timer")) global.pickup_flash_timer = 0;
if (!variable_global_exists("pickup_flash_col"))   global.pickup_flash_col   = c_white;
