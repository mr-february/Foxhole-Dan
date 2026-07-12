// === FX DECAY ===
if (global.shake_mag > 0.05)  global.shake_mag  *= 0.82; else global.shake_mag  = 0;
if (global.flash_timer > 0)   global.flash_timer--;

// === RUN STATS / COMBO WINDOW ===
scr_combo_tick();
if (global.game_state == 0) global.run_time++;

// === VERTICAL CAMERA ===
// Dan's Step_0 only self-drives the camera when no vertical controller exists.
// This controller runs at depth=-9999 (last), overriding with a smooth
// vertical follow each frame — exactly like obj_controller3.
var p = instance_find(obj_dan, 0);
if (p != noone && global.game_state == 0) {
    var cam_h  = camera_get_view_height(view_camera[0]);
    // Keep Dan 55% down from the top of the view so you can see above him
    var target = clamp(p.y - cam_h * 0.55, 0, room_height - cam_h);
    cam_y = lerp(cam_y, target, 0.10);

    // Altitude progress: 0 at base camp (y=2920), 1 at the summit threshold
    climb_pct = clamp(1 - ((p.y - climb_top_y) / (2920 - climb_top_y)), 0, 1);

    // === HAZARD SPAWNS — intensity rises as Dan climbs ===
    // --- Boulders ---
    boulder_timer--;
    if (boulder_timer <= 0) {
        var _bx = clamp(p.x + random_range(-520, 520), 48, room_width - 80);
        var _b  = instance_create_layer(_bx, cam_y - 80, "Instances", obj_boulder);
        // Roll roughly toward Dan's side of the slope, with some scatter
        _b.hspd = sign((p.x - _bx) + random_range(-260, 260)) * random_range(1.2, 2.6);
        if (_b.hspd == 0) _b.hspd = choose(-1, 1) * 1.6;
        // 420 frames at the base -> ~160 near the summit, scaled by difficulty
        boulder_timer = round((420 - 260 * climb_pct) * hazard_rate)
                      + irandom(60);
    }

    // --- Avalanches (one at a time) ---
    avalanche_timer--;
    if (avalanche_timer <= 0 && !instance_exists(obj_avalanche)) {
        var _av    = instance_create_layer(0, 0, "Instances", obj_avalanche);
        _av.band_w = room_width * random_range(0.45, 0.70);
        _av.band_x = clamp(p.x - _av.band_w * random_range(0.25, 0.75),
                           0, room_width - _av.band_w);
        // ~25s at the base -> ~13s near the summit, scaled by difficulty
        avalanche_timer = round((1500 - 720 * climb_pct) * hazard_rate)
                        + irandom(120);
    }

    // === WIN — Dan reaches the summit ===
    if (p.y < climb_top_y && transition_timer == 0) {
        global.game_state = 1;   // triggers the summit overlay in Draw_64
        transition_timer  = 1;
    }
}

// Re-assert the camera in ALL states — this controller steps last (created
// last in the room), and obj_dan self-drives the camera whenever
// obj_controller3 is absent. Without this, the view drifts on win/death.
camera_set_view_pos(view_camera[0], 0, cam_y);
if (global.game_state == 0 && global.shake_mag > 0.5) {
    camera_set_view_pos(view_camera[0],
        camera_get_view_x(view_camera[0]) + random_range(-global.shake_mag, global.shake_mag),
        camera_get_view_y(view_camera[0]) + random_range(-global.shake_mag, global.shake_mag));
}

// Summit transition: show the narrative beat, then on to The Siege
if (transition_timer > 0) {
    transition_timer++;
    if (transition_timer >= 240) {  // 4 seconds of text
        room_goto(Room5);           // defend Dan's mountaintop home
        exit;
    }
}

// === RESTART (from death) ===
if (global.game_state == 2) {
    var restart = keyboard_check_pressed(ord("R"));
    if (!restart && gamepad_is_connected(0)) {
        restart = gamepad_button_check_pressed(0, gp_start)
               || gamepad_button_check_pressed(0, gp_face1);
    }
    if (restart) {
        global.game_state = 0;
        room_restart();
    }
}
