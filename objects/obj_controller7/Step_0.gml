// === FX DECAY ===
if (global.shake_mag > 0.05) global.shake_mag *= 0.82; else global.shake_mag = 0;
if (global.flash_timer > 0)  global.flash_timer--;

// === RUN STATS / COMBO ===
scr_combo_tick();
if (global.game_state == 0) global.run_time++;

// === STEALTH ALERT — decays when no guard currently sees Dan ===
var anyone_sees = false;
with (obj_guard) { if (sees_dan) anyone_sees = true; }
if (!anyone_sees && global.game_state == 0) {
    global.stealth_alert = max(global.stealth_alert - 0.4, 0);
}

// === FULL ALERT — reinforcements once ===
if (global.stealth_alert >= 100 && !reinforced && global.game_state == 0) {
    reinforced = true;
    global.flash_timer = max(global.flash_timer, 12);
    global.shake_mag   = max(global.shake_mag, 6);
    if (instance_exists(obj_dan)) {
        var p = instance_find(obj_dan, 0);
        repeat (3) {
            var gx = clamp(p.x + choose(-600, 600) + irandom_range(-80, 80), 64, room_width - 64);
            instance_create_layer(gx, 552, "Instances", obj_guard);
        }
        repeat (2) {
            var sx = clamp(p.x + choose(-500, 500), 64, room_width - 64);
            instance_create_layer(sx, 552, "Instances", obj_enemy_soldier);
        }
    }
}

// === WIN — reach the exit ===
if (global.game_state == 0 && instance_exists(obj_dan)) {
    if (instance_find(obj_dan, 0).x > exit_x) {
        global.game_state = 1;
    }
}
if (global.game_state == 1) {
    win_timer++;
    if (win_timer >= 150) { room_goto(Room2); exit; }
}

// === RESTART ===
var restart = keyboard_check_pressed(ord("R"));
if (!restart && gamepad_is_connected(0)) {
    restart = gamepad_button_check_pressed(0, gp_start) || gamepad_button_check_pressed(0, gp_face1);
}
if ((global.game_state == 1 || global.game_state == 2) && restart) {
    global.game_state = 0;
    room_restart();
}
