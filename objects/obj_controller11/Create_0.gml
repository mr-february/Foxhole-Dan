// === obj_controller11 — THE FACILITY (Room11) level controller ===
// NON-persistent (Room1's obj_controller is destroyed by this room's creation code).
// Score/combo/run stats persist across the run — do NOT call scr_init_run() here.

audio_stop_all();
audio_play_sound(snd_music_room4, 100, true);

global.game_state = 0;   // 0=playing  1=win  2=dead  3=cutscene
depth   = -9999;         // step/draw last every frame
visible = true;

level_no  = 8;           // display level number for the HUD
win_timer = 0;           // counts up after the Handler falls, then room_goto(Room12)

// FX state — reset so nothing carries over from the previous room
global.shake_mag        = 0;
global.flash_timer      = 0;
global.kill_flash_timer = 0;

// Safety: if earlier rooms were skipped during dev, default the shared globals
if (!variable_global_exists("difficulty"))    global.difficulty    = 1;
if (!variable_global_exists("score"))         global.score         = 0;
if (!variable_global_exists("combo_timer"))   scr_init_run();
if (!variable_global_exists("clarity_timer")) global.clarity_timer = 0;
if (!variable_global_exists("memory_text")) {
    global.memory_text  = "";
    global.memory_timer = 0;
}
