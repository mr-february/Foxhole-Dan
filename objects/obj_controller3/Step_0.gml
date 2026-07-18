if (global.hitstop_timer > 0) global.hitstop_timer--;
if (global.shake_mag > 0.05)  global.shake_mag  *= 0.82; else global.shake_mag  = 0;
if (global.flash_timer > 0)   global.flash_timer--;
if (global.game_state == 0)   global.run_time++;

if (global.streak_timer > 0) {
    global.streak_timer--;
    if (global.streak_timer == 0) global.streak = 0;
}

// PTSD panic audio — fires once when stress crosses the redline
var _dp3 = instance_find(obj_dan, 0);
if (_dp3 != noone && global.game_state == 0) {
    if (_dp3.ptsd_meter > _dp3.ptsd_max * 0.85 && !ptsd_panic_played) {
        ptsd_panic_played = true;
        audio_play_sound(snd_ptsd_ring, 7, false);
        global.shake_mag = max(global.shake_mag, 3.0);
    }
    if (_dp3.ptsd_meter < _dp3.ptsd_max * 0.60) ptsd_panic_played = false;
}

// === RISING ARTILLERY BARRAGE ===
if (global.game_state == 0) {
    danger_y   -= danger_rise;
    danger_rise = min(danger_rise + 0.00025, 1.0);  // slowly accelerates
}

// === VERTICAL CAMERA ===
// Dan's Step_0 hardcodes target_cy=0 for horizontal levels.
// This controller runs at depth=-9999 (last), overriding that with a
// smooth vertical follow each frame.
var p = instance_find(obj_dan, 0);
if (p != noone && global.game_state == 0) {
    var cam_h  = camera_get_view_height(view_camera[0]);
    // Keep Dan 55% down from the top of the view so you can see above him
    var target = clamp(p.y - cam_h * 0.55, 0, room_height - cam_h);
    cam_y = lerp(cam_y, target, 0.10);
    camera_set_view_pos(view_camera[0], 0, cam_y);
    if (global.shake_mag > 0.5) {
        var _sm3 = global.shake_mag * global.shake_intensity;
        camera_set_view_pos(view_camera[0],
            camera_get_view_x(view_camera[0]) + random_range(-_sm3, _sm3),
            camera_get_view_y(view_camera[0]) + random_range(-_sm3, _sm3));
    }

    // Barrage damage — catching Dan in the danger zone
    if (p.y + 16 > danger_y && p.i_frames == 0) {
        p.hp      -= 2;
        p.i_frames = 8;
        global.shake_mag = max(global.shake_mag, 5.0);
    }

    // Dan reaches exit platform — start capture transition (captain must be defeated first)
    if (p.y < 280 && transition_timer == 0 && !instance_exists(obj_enemy_captain)) {
        global.game_state    = 1;  // triggers narrative overlay in Draw_64
        global.checkpoint3_y = 0;  // clear — level complete
        transition_timer     = 1;
    }
}

// Capture transition: show narrative text then load Room4
if (transition_timer > 0) {
    transition_timer++;
    if (transition_timer >= 240) {  // 4 seconds of text
        try { steam_set_achievement("ach_room3"); } catch (_ex) {}
        if (os_browser == browser_not_a_browser) {
            ini_open("foxhole_dan.ini");
            if (3 > ini_read_real("stats", "deepest_room", 0)) ini_write_real("stats", "deepest_room", 3);
            ini_close();
        }
        room_goto(Room9);  // -> DUST-OFF (chopper)
        exit;
    }
}

// === PTSD BLEED EFFECTS (Room3) ===
if (global.game_state == 0) {
    if (global.clarity_timer > 0) {
        global.clarity_timer--;
    } else {
        if (ptsd_bleed_timer > 0) {
            ptsd_bleed_timer--;
        } else {
            ptsd_bleed_timer = irandom_range(2400, 4800);
            var _type = irandom(2);
            if (_type == 0) audio_play_sound(snd_ptsd_ring, 8, false);
            if (_type == 1) audio_play_sound(snd_ptsd_horn, 8, false);
            var _msgs = [
                "just getting milk",
                "kids are home at 4",
                "it's not real",
                "call back later",
                "the window was open",
                "just the neighbors"
            ];
            ptsd_text_msg    = _msgs[irandom(5)];
            ptsd_text_active = 90;
        }
    }
    if (ptsd_text_active > 0) ptsd_text_active--;
}

// Restart (only from death, not from capture — Room4 handles its own restart)
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
