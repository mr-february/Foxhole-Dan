if (global.hitstop_timer > 0) global.hitstop_timer--;
if (global.shake_mag > 0.05) global.shake_mag *= 0.82; else global.shake_mag = 0;
if (global.flash_timer > 0)  global.flash_timer--;

scr_combo_tick();

if (global.game_state == 0) {
    global.run_time++;
    scroll += scroll_speed;

    // === SPAWN TARGETS ===
    if (scroll < scroll_target) {
        spawn_timer--;
        if (spawn_timer <= 0) {
            // Difficulty + progress bias the mix toward tougher targets later.
            var prog = scroll / scroll_target;
            var roll = random(1);
            var tt = 0;
            if (roll > 0.85 - prog * 0.25) tt = 3;        // enemy chopper
            else if (roll > 0.65 - prog * 0.2) tt = 2;    // RPG team
            else if (roll > 0.4) tt = 1;                  // technical
            else tt = 0;                                  // troop
            var ty = (tt == 3) ? irandom_range(120, 380) : (ground_y - irandom_range(0, 40));
            var e = instance_create_layer(room_width + 40, ty, "Instances", obj_heli_target);
            e.target_type = tt;
            spawn_timer = spawn_cd + irandom(30);
        }
    }

    // === WIN at the LZ (and screen mostly clear) ===
    if (scroll >= scroll_target && instance_number(obj_heli_target) == 0) {
        global.game_state = 1;
    }
}

if (global.game_state == 1) {
    win_timer++;
    if (win_timer >= 160) { room_goto(Room10); exit; }
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
