global.game_state       = 0;
global.vol_sfx          = 0.8;
global.vol_music        = 0.8;
global.music_inst       = -1;
global.score            = 0;
scr_init_run();
global.kill_flash_timer = 0;
global.memory_text      = "";
global.memory_timer     = 0;
global.checkpoint3_y    = 0;
global.high_score       = 0;
global.streak             = 0;
global.streak_timer       = 0;
global.pickup_flash_timer = 0;
global.pickup_flash_col   = c_white;
if (!variable_global_exists("pending_score")) global.pending_score = 0;

// Defensive defaults for globals normally first-set by obj_controller (Room1) or
// obj_dan's Create — needed so the dev level-select (T on the title screen) can
// jump straight into any room without first running through Room1.
if (!variable_global_exists("shake_intensity"))    global.shake_intensity    = 1.0;
if (!variable_global_exists("key_jump"))           global.key_jump           = vk_space;
if (!variable_global_exists("key_shoot"))          global.key_shoot          = ord("J");
if (!variable_global_exists("key_grenade"))        global.key_grenade        = ord("K");
if (!variable_global_exists("key_roll"))           global.key_roll           = vk_shift;
if (!variable_global_exists("clarity_timer"))      global.clarity_timer      = 0;
if (!variable_global_exists("ptsd_flicker_count")) global.ptsd_flicker_count = 0;
if (!variable_global_exists("total_deaths"))       global.total_deaths       = 0;
if (!variable_global_exists("total_clarity"))      global.total_clarity      = 0;
if (!variable_global_exists("play_seconds"))       global.play_seconds       = 0;
if (!variable_global_exists("rage_timer"))         global.rage_timer         = 0;
if (!variable_global_exists("pstat_lifetime_deaths")) global.pstat_lifetime_deaths = 0;

instance_create_layer(0, 0, "Instances", obj_title_controller);
