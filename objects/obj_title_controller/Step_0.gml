// Resume title music if audio was unavailable when title screen started
if (audio_system_is_available() && !audio_is_playing(snd_music_title)) {
    audio_play_sound(snd_music_title, 100, true);
}

var press_start    = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_return)
                  || (state == 0 && mouse_check_button_pressed(mb_left));
var press_controls = keyboard_check_pressed(ord("C"));
var press_back     = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace)
                  || (state == 1 && mouse_check_button_pressed(mb_left));
var press_up       = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
var press_down     = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));

var press_left     = keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"));
var press_right    = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var press_settings = keyboard_check_pressed(ord("O"));

if (gamepad_is_connected(0)) {
    press_start    = press_start    || gamepad_button_check_pressed(0, gp_face1)
                                    || gamepad_button_check_pressed(0, gp_start);
    press_controls = press_controls || gamepad_button_check_pressed(0, gp_face3);
    press_back     = press_back     || gamepad_button_check_pressed(0, gp_face2);
    press_up       = press_up       || gamepad_button_check_pressed(0, gp_padu);
    press_down     = press_down     || gamepad_button_check_pressed(0, gp_padd);
    press_left     = press_left     || gamepad_button_check_pressed(0, gp_padl);
    press_right    = press_right    || gamepad_button_check_pressed(0, gp_padr);
    press_settings = press_settings || gamepad_button_check_pressed(0, gp_select);
}

// ENDLESS launch (unlocked after beating the story). E / gamepad RB.
var press_endless = keyboard_check_pressed(ord("E"));
if (gamepad_is_connected(0)) press_endless = press_endless || gamepad_button_check_pressed(0, gp_shoulderr);

if (state == 0) {
    if (press_start)    state = 2;   // go to difficulty select before playing
    if (press_controls) state = 1;
    if (press_endless && endless_unlocked) {
        global.difficulty = 3;       // Endless always runs at the hardest tuning
        room_goto(Room14);
    }
    if (press_settings) state = 3;
    if (keyboard_check_pressed(ord("L"))) {
        state          = 4;
        lb_needs_fetch = true;
        lb_scores      = [];
        lb_error       = false;
    }
} else if (state == 1) {
    if (press_back || press_start) state = 0;
} else if (state == 2) {
    if (press_up)   diff_sel = (diff_sel - 1 + 4) mod 4;
    if (press_down) diff_sel = (diff_sel + 1) mod 4;
    if (press_start) {
        global.difficulty = diff_sel;
        room_goto(Room1);
    }
    if (press_back) state = 0;
    if (mouse_check_button_pressed(mb_left)) {
        var _panel_x = 960 - 460;
        var _panel_w = 920;
        var _row_h   = 112;
        var _start_y = 130;
        if (mouse_x >= _panel_x && mouse_x <= _panel_x + _panel_w) {
            for (var _di = 0; _di < 4; _di++) {
                var _ry = _start_y + _di * _row_h;
                if (mouse_y >= _ry && mouse_y < _ry + _row_h - 6) {
                    diff_sel = _di;
                    global.difficulty = diff_sel;
                    room_goto(Room1);
                }
            }
        }
    }
} else if (state == 3) {
    if (press_up || press_down) settings_sel = 1 - settings_sel;
    var _step = 0.05;
    if (press_left) {
        if (settings_sel == 0) global.vol_music = max(0, global.vol_music - _step);
        else                   global.vol_sfx   = max(0, global.vol_sfx   - _step);
    }
    if (press_right) {
        if (settings_sel == 0) global.vol_music = min(1, global.vol_music + _step);
        else                   global.vol_sfx   = min(1, global.vol_sfx   + _step);
    }
    if (press_left || press_right) {
        audio_group_set_gain(audiogroup_default, global.vol_sfx, 0);
        if (global.music_inst >= 0) {
            var _mg = (global.vol_sfx > 0.001) ? clamp(global.vol_music / global.vol_sfx, 0, 5) : 0;
            audio_sound_gain(global.music_inst, _mg, 0);
        }
    }
    if (press_back || press_start) state = 0;

} else if (state == 4) {
    // Leaderboard view — load from local ini
    if (lb_needs_fetch) {
        lb_needs_fetch = false;
        lb_scores      = [];
        lb_error       = false;
        ini_open("foxhole_dan.ini");
        for (var _i = 0; _i < 10; _i++) {
            var _sc = ini_read_real("leaderboard", "score_" + string(_i), -1);
            if (_sc < 0) break;
            var _nm = ini_read_string("leaderboard", "name_" + string(_i), "???");
            array_push(lb_scores, { name: _nm, score: _sc });
        }
        ini_close();
    }
    if (press_back || press_start) state = 0;

} else if (state == 5) {
    // Name entry after completing the game
    var _ks = keyboard_string;
    var _filtered = "";
    for (var _fi = 1; _fi <= min(string_length(_ks), 24); _fi++) {
        var _c = string_char_at(_ks, _fi);
        var _o = ord(_c);
        if ((_o >= 65 && _o <= 90) || (_o >= 97 && _o <= 122) ||
            (_o >= 48 && _o <= 57) || _c == " " || _c == "-" || _c == "_") {
            if (string_length(_filtered) < 12) _filtered += _c;
        }
    }
    lb_name         = _filtered;
    keyboard_string = _filtered;

    var press_confirm = keyboard_check_pressed(vk_return);
    if (gamepad_is_connected(0)) press_confirm = press_confirm || gamepad_button_check_pressed(0, gp_start);

    if (press_confirm && string_length(lb_name) > 0) {
        // Load existing entries from ini
        var _sc_arr = [];
        var _nm_arr = [];
        ini_open("foxhole_dan.ini");
        for (var _i = 0; _i < 10; _i++) {
            var _sc = ini_read_real("leaderboard", "score_" + string(_i), -1);
            if (_sc < 0) break;
            array_push(_sc_arr, _sc);
            array_push(_nm_arr, ini_read_string("leaderboard", "name_" + string(_i), "???"));
        }
        // Insert new score in descending order
        var _new_sc = global.pending_score;
        var _new_nm = lb_name;
        var _placed = false;
        for (var _i = 0; _i < array_length(_sc_arr); _i++) {
            if (_new_sc > _sc_arr[_i]) {
                array_insert(_sc_arr, _i, _new_sc);
                array_insert(_nm_arr, _i, _new_nm);
                _placed = true;
                break;
            }
        }
        if (!_placed && array_length(_sc_arr) < 10) {
            array_push(_sc_arr, _new_sc);
            array_push(_nm_arr, _new_nm);
        }
        // Write back top 10; mark end with -1
        var _count = min(array_length(_sc_arr), 10);
        for (var _i = 0; _i < _count; _i++) {
            ini_write_real("leaderboard", "score_" + string(_i), _sc_arr[_i]);
            ini_write_string("leaderboard", "name_" + string(_i), _nm_arr[_i]);
        }
        for (var _i = _count; _i < 10; _i++) {
            ini_write_real("leaderboard", "score_" + string(_i), -1);
        }
        // Update best score display
        if (_new_sc > global.high_score) {
            global.high_score = _new_sc;
            ini_write_real("saves", "high_score", global.high_score);
        }
        ini_close();
        global.pending_score = 0;
        keyboard_string      = "";
        lb_needs_fetch       = true;
        state                = 4;
    }

    if (press_back) {
        global.pending_score = 0;
        keyboard_string      = "";
        state                = 0;
    }
}
