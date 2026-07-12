audio_pause_all();
audio_resume_sound(csnd);

if (fade > 0) { fade--; exit; }

var press = keyboard_check_pressed(vk_space)
         || keyboard_check_pressed(vk_return)
         || mouse_check_button_pressed(mb_left);
if (gamepad_is_connected(0)) {
    press = press
         || gamepad_button_check_pressed(0, gp_face1)
         || gamepad_button_check_pressed(0, gp_start);
}

if (press) {
    panel++;
    fade = 28;
    if (panel >= panels) {
        global.game_state = 0;
        try { steam_set_achievement("ach_room1"); } catch (_ex) {}
        if (os_browser == browser_not_a_browser) {
            ini_open("foxhole_dan.ini");
            if (1 > ini_read_real("stats", "deepest_room", 0)) ini_write_real("stats", "deepest_room", 1);
            ini_close();
        }
        room_goto(Room7);  // -> COLD SWEAT (stealth)
    }
}
