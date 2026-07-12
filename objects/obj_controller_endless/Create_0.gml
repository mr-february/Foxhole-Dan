// === obj_controller_endless — ENDLESS SURVIVAL controller ===
audio_stop_all();
audio_play_sound(snd_music_room1, 100, true);

global.game_state = 0;
depth    = -9999;
visible  = true;

scr_init_run();                 // fresh run: score, combo, kills, time
global.score = 0;

wave         = 0;
phase        = 0;               // 0 = intermission, 1 = fighting
inter_timer  = 90;             // countdown before wave 1
to_spawn     = 0;
spawn_timer  = 0;
banner_timer = 0;

// The full roster to draw from (unlocks harder types as waves rise).
roster_basic = [obj_enemy_soldier, obj_enemy_dog, obj_ambusher];
roster_mid   = [obj_enemy_soldier, obj_enemy_heavy, obj_enemy_sniper, obj_enemy_flamer, obj_sapper, obj_enemy_dog, obj_ambusher];
roster_hard  = [obj_enemy_heavy, obj_enemy_sniper, obj_enemy_rocket, obj_mg_nest, obj_enemy_medic, obj_enemy_flamer, obj_enemy_elite, obj_sapper];

// --- Death / submit flow ---
submit_state = 0;               // 0 = playing, 1 = entering initials, 2 = submitted
initials     = ["A", "A", "A"];
init_pos     = 0;
input_delay  = 0;
run_submitted = false;

// Local bests loaded for display.
ini_open("foxhole_dan.ini");
best_score = ini_read_real("saves", "endless_best_score", 0);
best_wave  = ini_read_real("saves", "endless_best_wave", 0);
last_init  = ini_read_string("saves", "last_initials", "AAA");
ini_close();

// Seed initials from last used.
if (string_length(last_init) >= 3) {
    initials[0] = string_char_at(last_init, 1);
    initials[1] = string_char_at(last_init, 2);
    initials[2] = string_char_at(last_init, 3);
}

global.shake_mag = 0;
global.flash_timer = 0;
