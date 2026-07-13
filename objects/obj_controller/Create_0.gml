visible = true;

audio_stop_all();
global.music_inst       = audio_play_sound(snd_music_room1, 100, true);
global.game_state       = 0;  // 0=playing  1=win  2=dead  4=paused
global.score            = 0;
scr_init_run();
global.shake_mag        = 0;
global.hitstop_timer    = 0;
global.flash_timer      = 0;
global.kill_flash_timer = 0;
global.memory_text      = "";
global.memory_timer     = 0;
global.checkpoint3_y    = 0;
global.streak             = 0;
global.streak_timer       = 0;
global.pickup_flash_timer = 0;
global.pickup_flash_col   = c_white;
room_fade  = 45;
card_timer = 190;
ptsd_panic_played = false;

// Safety: if Room0 was skipped during dev, default to Normal
if (!variable_global_exists("difficulty"))  global.difficulty  = 1;
if (!variable_global_exists("vol_sfx"))     global.vol_sfx     = 0.8;
if (!variable_global_exists("vol_music"))   global.vol_music   = 0.8;

// Accessibility — camera shake intensity multiplier, and remappable action keys
if (!variable_global_exists("shake_intensity")) global.shake_intensity = 1.0;
if (!variable_global_exists("key_jump"))    global.key_jump    = vk_space;
if (!variable_global_exists("key_shoot"))   global.key_shoot   = ord("J");
if (!variable_global_exists("key_grenade")) global.key_grenade = ord("K");
if (!variable_global_exists("key_roll"))    global.key_roll    = vk_shift;

// Pause state
pause_sel          = 0;    // 0=resume  1=settings  2=quit
pause_settings     = false;
pause_settings_sel = 0;    // 0=music 1=sfx 2=shake 3=jump 4=shoot 5=grenade 6=roll
remap_waiting       = false;

// PTSD bleed state (persists across rooms via persistent object)
global.clarity_timer       = 0;    // frames of PTSD suppression remaining
global.ptsd_flicker_count  = 0;    // lifetime enemy flicker sightings
global.total_deaths        = 0;    // lifetime death count
global.total_clarity       = 0;    // lifetime clarity pickups collected
global.play_seconds        = 0;    // in-session seconds played
play_second_tick           = 0;    // step counter for 1-second intervals
ptsd_bleed_timer = irandom_range(3600, 7200);  // 60-120 sec before first intrusion
ptsd_text_active = 0;
ptsd_text_msg    = "";

global.rage_timer      = 0;
global.boss_intro_done = false;

// === PERSISTENT STATS (local save file — survives across sessions) ===
// global.run_kills/run_time are reset by scr_init_run() above; run duration
// is tracked via the shared global.run_time (ticked by every room controller).
global.pstat_best_time       = 0;
global.pstat_total_runs      = 0;
global.pstat_total_wins      = 0;
global.pstat_lifetime_deaths = 0;
global.pstat_lifetime_kills  = 0;
global.pstat_deepest_room    = 0;
if (os_browser == browser_not_a_browser) {
    ini_open("foxhole_dan.ini");
    global.pstat_best_time       = ini_read_real("stats", "best_time", 0);
    global.pstat_total_runs      = ini_read_real("stats", "total_runs", 0);
    global.pstat_total_wins      = ini_read_real("stats", "total_wins", 0);
    global.pstat_lifetime_deaths = ini_read_real("stats", "lifetime_deaths", 0);
    global.pstat_lifetime_kills  = ini_read_real("stats", "lifetime_kills", 0);
    global.pstat_deepest_room    = ini_read_real("stats", "deepest_room", 0);
    ini_write_real("stats", "total_runs", global.pstat_total_runs + 1);
    ini_close();
    global.pstat_total_runs += 1;
}

// (touch input handled via device_mouse_x_to_gui in Dan's Step_0 and controller Step_0)
