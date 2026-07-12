// === SHARED PER-FRAME PLUMBING ===
scr_combo_tick();
global.run_time++;

// === INPUT === (mirrors obj_controller4)
var gp   = gamepad_is_connected(0);
var dead = 0.2;

// pressed (single-frame) inputs
var key_left_p  = keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"));
var key_right_p = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var key_space_p = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_return);

// held inputs
var key_j_h = keyboard_check(ord("J"));

if (gp) {
    var lx = gamepad_axis_value(0, gp_axislh);
    if (lx < -dead) key_left_p  = true;
    if (lx >  dead) key_right_p = true;
    if (gamepad_button_check_pressed(0, gp_padl))  key_left_p  = true;
    if (gamepad_button_check_pressed(0, gp_padr))  key_right_p = true;
    if (gamepad_button_check_pressed(0, gp_face1)) key_space_p = true;  // A/Cross
    if (gamepad_button_check(0, gp_shoulderl))     key_j_h     = true;  // LB/L1
}

// === PHASE 0: INTRO SLIDES ===
if (phase == 0) {
    slide_fade_in++;
    if (slide_fade_in > 30 && key_space_p) {
        intro_slide++;
        slide_fade_in = 0;
        if (intro_slide >= intro_slides) {
            // Begin the interrogation — first question card
            phase          = 1;
            ch_index       = 0;
            ch_state       = 0;
            ch_state_timer = 170;
        }
    }
}

// === PHASE 1: THE INTERROGATION (challenge machine) ===
// (else-if: a phase transition must not leak this frame's input into the next phase)
else if (phase == 1) {

    if (resolve_flash > 0) resolve_flash--;
    if (def_flash > 0) def_flash--;
    if (def_flash < 0) def_flash++;

    // ---- ch_state 0: The Handler's question ----
    if (ch_state == 0) {
        ch_state_timer--;
        if (ch_state_timer <= 0 || key_space_p) {
            // Arm the challenge. Later rounds are shorter and meaner.
            ch_state    = 1;
            ch_time_now = max(ch_time_base - ch_index * 45, 5 * 60);
            ch_timer    = ch_time_now;

            var _type = ch_types[ch_index];
            if (_type == 0) {                       // MASH
                mash_progress = 0;
            }
            if (_type == 1) {                       // HOLD
                needle_pos = 0;
                needle_t   = 0;
                zone_time  = 0;
            }
            if (_type == 2) {                       // DEFLECT
                def_done         = 0;
                def_miss         = 0;
                def_need_now     = (ch_index >= 4) ? 8 : def_need;
                def_window_now   = (ch_index >= 4) ? floor(def_window * 0.75) : def_window;
                def_current      = irandom(1);
                def_prompt_timer = def_window_now;
            }
        }
    }

    // ---- ch_state 1: challenge active ----
    else if (ch_state == 1) {
        ch_timer--;
        var _type   = ch_types[ch_index];
        var _passed = false;
        var _failed = false;

        // --- Type 0: MASH resist ---
        if (_type == 0) {
            var _hard = (ch_index >= 3) ? 1.5 : 1.0;   // second mash round is meaner
            if (key_space_p) {
                mash_progress = min(mash_progress + mash_gain, 1.0);
            }
            if (mash_progress >= 1.0) _passed = true;  // check before decay
            mash_progress = max(mash_progress - mash_decay * _hard, 0);
            if (!_passed && ch_timer <= 0) _failed = true;
        }

        // --- Type 1: HOLD steady (needle) ---
        if (_type == 1) {
            needle_t++;
            // Drug pressure pushes the needle right, in waves with jitter
            var _push = needle_push * (0.55 + 0.45 * sin(needle_t * 0.045))
                      + random_range(-0.002, 0.004);
            needle_pos += _push;
            if (key_j_h) needle_pos -= hold_force;     // pulse the hold — pinning it overshoots
            needle_pos = clamp(needle_pos, -1, 1);

            if (abs(needle_pos) <= zone_half) zone_time++;
            if (zone_time >= zone_need) _passed = true;
            if (!_passed && ch_timer <= 0) _failed = true;
        }

        // --- Type 2: DEFLECT prompts ---
        if (_type == 2) {
            def_prompt_timer--;
            var _answered = 0;   // 0 = none, 1 = correct, -1 = wrong/late
            if (key_left_p || key_right_p) {
                var _press_dir = key_right_p ? 1 : 0;
                _answered = (_press_dir == def_current) ? 1 : -1;
            } else if (def_prompt_timer <= 0) {
                _answered = -1;
            }
            if (_answered != 0) {
                if (_answered == 1) { def_done++; def_flash =  18; }
                else                { def_miss++; def_flash = -18; }
                def_current      = irandom(1);
                def_prompt_timer = def_window_now;
            }
            if (def_done >= def_need_now) _passed = true;
            if (!_passed && (def_miss >= def_maxmiss || ch_timer <= 0)) _failed = true;
        }

        // --- Resolve the challenge ---
        if (_passed) {
            challenges_passed++;
            ch_result      = 1;
            ch_state       = 2;
            ch_state_timer = 110;
        } else if (_failed) {
            challenges_failed++;
            resolve        = max(resolve - 25, 0);
            resolve_flash  = 45;
            ch_result      = -1;
            ch_state       = 2;
            ch_state_timer = 110;
        }
    }

    // ---- ch_state 2: result card ----
    else {
        ch_state_timer--;
        if (ch_state_timer <= 0) {
            ch_index++;
            if (ch_index >= ch_count) {
                // Session over — branch the story. EITHER WAY the level completes.
                // 0 fails (100) or 1 fail (75) = Dan holds out; 2+ fails = he breaks.
                global.interro_resisted = (resolve >= 60);
                phase           = 2;
                end_timer       = 0;
                narrative_slide = 0;
                slide_fade_in   = 0;
            } else {
                ch_state       = 0;
                ch_state_timer = 170;
            }
        }
    }
}

// === PHASE 2: OUTCOME SLIDES ===
else if (phase == 2) {
    end_timer++;
    slide_fade_in++;

    // First 2.5 seconds: verdict card only — input locked
    if (end_timer > 150 && narrative_slide < outcome_slides - 1) {
        if (key_space_p) {
            narrative_slide++;
            slide_fade_in = 0;
        }
    }

    // After the final slide, auto-advance to the Chair (Room4 bomb-defuse finale)
    if (narrative_slide >= outcome_slides - 1) {
        if (slide_fade_in >= 240) {
            global.game_state = 0;
            room_goto(Room4);   // "The Chair" — the bomb-defuse finale follows
        }
    }

    // Restart stays available during the slides (with input lockout)
    var _restart = keyboard_check_pressed(ord("R"));
    if (!_restart && gp) {
        _restart = gamepad_button_check_pressed(0, gp_start);
    }
    if (end_timer > 90 && _restart) {
        global.game_state = 0;
        room_restart();
    }
}
