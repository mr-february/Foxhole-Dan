if (global.game_state == 0) global.run_time++;

// === PAUSE ===
var _pause_toggle = keyboard_check_pressed(vk_escape);
if (gamepad_is_connected(0)) _pause_toggle = _pause_toggle || gamepad_button_check_pressed(0, gp_select);
if (_pause_toggle) {
    if (global.game_state == 0) {
        global.game_state  = 4;
        pause_sel          = 0;
        pause_settings     = false;
    } else if (global.game_state == 4) {
        if (pause_settings) pause_settings = false;
        else global.game_state = 0;
    }
}
if (global.game_state == 4) {
    var _pu = keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W"));
    var _pd = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));
    var _pl = keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"));
    var _pr = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
    var _pc = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_return);
    if (gamepad_is_connected(0)) {
        _pu = _pu || gamepad_button_check_pressed(0, gp_padu);
        _pd = _pd || gamepad_button_check_pressed(0, gp_padd);
        _pl = _pl || gamepad_button_check_pressed(0, gp_padl);
        _pr = _pr || gamepad_button_check_pressed(0, gp_padr);
        _pc = _pc || gamepad_button_check_pressed(0, gp_face1);
        if (gamepad_button_check_pressed(0, gp_start)) global.game_state = 0;
    }
    if (!pause_settings) {
        if (_pu) pause_sel = (pause_sel + 2) mod 3;
        if (_pd) pause_sel = (pause_sel + 1) mod 3;
        if (_pc) {
            if (pause_sel == 0) global.game_state = 0;
            if (pause_sel == 1) { pause_settings = true; pause_settings_sel = 0; }
            if (pause_sel == 2) { audio_stop_all(); room_goto(Room0); }
        }
    } else {
        if (_pu || _pd) pause_settings_sel = 1 - pause_settings_sel;
        var _step = 0.05;
        if (_pl) {
            if (pause_settings_sel == 0) global.vol_music = max(0, global.vol_music - _step);
            else                         global.vol_sfx   = max(0, global.vol_sfx   - _step);
        }
        if (_pr) {
            if (pause_settings_sel == 0) global.vol_music = min(1, global.vol_music + _step);
            else                         global.vol_sfx   = min(1, global.vol_sfx   + _step);
        }
        if (_pl || _pr) {
            audio_group_set_gain(audiogroup_default, global.vol_sfx, 0);
            if (global.music_inst >= 0) {
                var _mg = (global.vol_sfx > 0.001) ? clamp(global.vol_music / global.vol_sfx, 0, 5) : 0;
                audio_sound_gain(global.music_inst, _mg, 0);
            }
        }
    }
    exit;
}

if (global.shake_mag > 0.05)  global.shake_mag  *= 0.82; else global.shake_mag  = 0;
if (global.flash_timer > 0)   global.flash_timer--;

if (global.streak_timer > 0) {
    global.streak_timer--;
    if (global.streak_timer == 0) global.streak = 0;
}

var restart = keyboard_check_pressed(ord("R"));
if (!restart && gamepad_is_connected(0)) {
    restart = gamepad_button_check_pressed(0, gp_start)
           || gamepad_button_check_pressed(0, gp_face1);
}
if (global.game_state == 1 && restart) {
    global.game_state = 0;
    room_goto(Room8);  // -> OVERWATCH (sniper); matches obj_cutscene2
}
if (global.game_state == 2 && restart) {
    global.game_state = 0;
    room_restart();
}
