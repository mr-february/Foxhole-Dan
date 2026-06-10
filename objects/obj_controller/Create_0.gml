audio_stop_all();
audio_play_sound(snd_music_room1, 100, true);
global.game_state       = 0;  // 0=playing  1=win  2=dead
global.score            = 0;
global.shake_mag        = 0;
global.flash_timer      = 0;
global.kill_flash_timer = 0;
global.memory_text      = "";
global.memory_timer     = 0;
global.checkpoint3_y    = 0;
visible = true;

// Safety: if Room0 was skipped during dev, default to Normal
if (!variable_global_exists("difficulty")) global.difficulty = 1;

// PTSD bleed state (persists across rooms via persistent object)
global.clarity_timer       = 0;    // frames of PTSD suppression remaining
global.ptsd_flicker_count  = 0;    // lifetime enemy flicker sightings
global.total_deaths        = 0;    // lifetime death count
global.total_clarity       = 0;    // lifetime clarity pickups collected
global.play_seconds        = 0;    // in-session seconds played
play_second_tick           = 0;    // step counter for 1-second intervals
