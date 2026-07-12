if (global.shake_mag > 0.05)  global.shake_mag  *= 0.82; else global.shake_mag  = 0;
if (global.flash_timer > 0)   global.flash_timer--;

scr_combo_tick();
global.run_time++;

var restart = keyboard_check_pressed(ord("R"));
if (!restart && gamepad_is_connected(0)) {
    restart = gamepad_button_check_pressed(0, gp_start)
           || gamepad_button_check_pressed(0, gp_face1);
}
if ((global.game_state == 1 || global.game_state == 2) && restart) {
    global.game_state = 0;
    room_restart();
}

// === PTSD BLEED EFFECTS (Room1 only) ===
if (room == Room1 && global.game_state == 0) {
    if (global.clarity_timer > 0) {
        global.clarity_timer--;
    } else {
        if (ptsd_bleed_timer > 0) {
            ptsd_bleed_timer--;
        } else {
            ptsd_bleed_timer = irandom_range(3600, 7200);
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
    // Playtime counter
    play_second_tick++;
    if (play_second_tick >= 60) {
        play_second_tick = 0;
        global.play_seconds++;
        if (global.play_seconds == 6000) steam_set_achievement("ach_playtime");
    }
}
