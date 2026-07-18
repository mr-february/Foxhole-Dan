// === FX DECAY ===
if (global.hitstop_timer > 0) global.hitstop_timer--;
if (global.shake_mag > 0.05) global.shake_mag *= 0.82; else global.shake_mag = 0;
if (global.flash_timer > 0)  global.flash_timer--;

scr_combo_tick();
if (global.game_state == 0) global.run_time++;

if (global.game_state == 0) {
    // --- Start a wave ---
    if (phase == 0) {
        to_spawn = wave_counts[wave_index];
        phase = 1;
        spawn_timer = 40;
    }

    // --- Spawn + clear the current wave ---
    if (phase == 1) {
        if (to_spawn > 0) {
            spawn_timer--;
            if (spawn_timer <= 0) {
                var ex = room_width + irandom_range(0, 200);
                var e  = instance_create_layer(ex, street_y + irandom_range(-30, 20), "Instances", obj_street_enemy);
                to_spawn--;
                spawn_timer = 30 + irandom(40);
            }
        } else if (!instance_exists(obj_street_enemy)) {
            // Wave cleared
            wave_index++;
            if (wave_index >= total_waves) {
                phase = 3;                 // all waves done -> win
            } else {
                phase = 2;
                wave_gap = 120;            // breather between waves
            }
        }
    }

    // --- Gap between waves ---
    if (phase == 2) {
        wave_gap--;
        if (wave_gap <= 0) phase = 0;
    }

    // --- Win ---
    if (phase == 3) {
        global.game_state = 1;
    }
}

if (global.game_state == 1) {
    win_timer++;
    if (win_timer >= 150) { room_goto(Room3); exit; }
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
