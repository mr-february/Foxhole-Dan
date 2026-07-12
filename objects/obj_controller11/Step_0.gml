// === FX DECAY ===
if (global.shake_mag > 0.05)  global.shake_mag  *= 0.82; else global.shake_mag  = 0;
if (global.flash_timer > 0)   global.flash_timer--;

// === COMBO / RUN CLOCK ===
scr_combo_tick();
global.run_time++;

// === WIN — the Handler sets global.game_state = 1 on death ===
// Short delay so the kill FX and LEVEL COMPLETE overlay land, then advance.
if (global.game_state == 1) {
    win_timer++;
    if (win_timer >= 210) {   // ~3.5 seconds
        room_goto(Room12);
        exit;
    }
}

// === RESTART ===
var restart = keyboard_check_pressed(ord("R"));
if (!restart && gamepad_is_connected(0)) {
    restart = gamepad_button_check_pressed(0, gp_start)
           || gamepad_button_check_pressed(0, gp_face1);
}
if ((global.game_state == 1 || global.game_state == 2) && restart) {
    global.game_state = 0;
    room_restart();
}
