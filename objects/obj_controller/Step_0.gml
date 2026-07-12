// Resume Room1 music if audio was unavailable (suspended AudioContext) when the room started
if (room == Room1 && global.game_state == 0) {
    if (audio_system_is_available() && !audio_is_playing(snd_music_room1)) {
        global.music_inst = audio_play_sound(snd_music_room1, 100, true);
    }
}

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
            if (pause_sel == 1) { pause_settings = true; pause_settings_sel = 0; remap_waiting = false; }
            if (pause_sel == 2) { audio_stop_all(); room_goto(Room0); }
        }
    } else if (remap_waiting) {
        // Listening for the next key press to bind to the selected action.
        if (keyboard_key != 0) {
            if (keyboard_key != vk_escape) {
                if (pause_settings_sel == 3) global.key_jump    = keyboard_key;
                if (pause_settings_sel == 4) global.key_shoot   = keyboard_key;
                if (pause_settings_sel == 5) global.key_grenade = keyboard_key;
                if (pause_settings_sel == 6) global.key_roll    = keyboard_key;
            }
            remap_waiting = false;
        }
    } else {
        if (_pu) pause_settings_sel = (pause_settings_sel + 6) mod 7;
        if (_pd) pause_settings_sel = (pause_settings_sel + 1) mod 7;

        if (pause_settings_sel <= 2) {
            var _step = 0.05;
            if (_pl) {
                if (pause_settings_sel == 0)      global.vol_music       = max(0, global.vol_music - _step);
                else if (pause_settings_sel == 1) global.vol_sfx         = max(0, global.vol_sfx - _step);
                else                              global.shake_intensity = max(0, global.shake_intensity - _step);
            }
            if (_pr) {
                if (pause_settings_sel == 0)      global.vol_music       = min(1, global.vol_music + _step);
                else if (pause_settings_sel == 1) global.vol_sfx         = min(1, global.vol_sfx + _step);
                else                              global.shake_intensity = min(1, global.shake_intensity + _step);
            }
            if (_pl || _pr) {
                audio_group_set_gain(audiogroup_default, global.vol_sfx, 0);
                if (global.music_inst >= 0) {
                    var _mg = (global.vol_sfx > 0.001) ? clamp(global.vol_music / global.vol_sfx, 0, 5) : 0;
                    audio_sound_gain(global.music_inst, _mg, 0);
                }
            }
        } else if (_pc) {
            remap_waiting = true;
        }
    }
    exit;
}

if (global.shake_mag > 0.05)  global.shake_mag  *= 0.82; else global.shake_mag  = 0;
if (global.flash_timer > 0)   global.flash_timer--;
if (global.hitstop_timer > 0) global.hitstop_timer--;

scr_combo_tick();
global.run_time++;

var restart = keyboard_check_pressed(ord("R"));
if (!restart && gamepad_is_connected(0)) {
    restart = gamepad_button_check_pressed(0, gp_start)
           || gamepad_button_check_pressed(0, gp_face1);
}
if (global.game_state == 1 && restart) {
    global.game_state = 0;
    room_goto(Room2);
}
if (global.game_state == 2 && restart) {
    global.game_state = 0;
    room_restart();
}

// === KILL STREAK DECAY (Room1 only — other rooms run their own controllers) ===
if (room == Room1 && global.streak_timer > 0) {
    global.streak_timer--;
    if (global.streak_timer == 0) global.streak = 0;
}

// === RAGE MODE COUNTDOWN ===
if (global.rage_timer > 0) global.rage_timer--;

// === BOSS INTRO CINEMATIC ===
if (room == Room1 && !global.boss_intro_done && instance_exists(obj_boss)) {
    var _dp = instance_find(obj_dan, 0);
    if (_dp != noone && _dp.x > 2800) {
        global.boss_intro_done = true;
        global.memory_text     = "THE SERGEANT";
        global.memory_timer    = 210;
        global.shake_mag       = max(global.shake_mag, 16.0);
    }
}

// === PTSD BLEED EFFECTS (Room1 only) ===
if (room == Room1 && global.game_state == 0) {
    var _dp = instance_find(obj_dan, 0);
    if (_dp != noone) {
        if (_dp.ptsd_meter > _dp.ptsd_max * 0.85 && !ptsd_panic_played) {
            ptsd_panic_played = true;
            audio_play_sound(snd_ptsd_ring, 7, false);
            global.shake_mag = max(global.shake_mag, 3.0);
        }
        if (_dp.ptsd_meter < _dp.ptsd_max * 0.60) ptsd_panic_played = false;
    }
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
        if (global.play_seconds == 6000) { try { steam_set_achievement("ach_playtime"); } catch (_ex) {} }
    }
}
