// === INPUT ===
var gp   = gamepad_is_connected(0);
var dead = 0.2;

// pressed (single-frame) inputs
var key_up_p    = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
var key_down_p  = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));
var key_left_p  = keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"));
var key_right_p = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var key_space_p = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_return);

// held inputs
var key_left_h  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var key_right_h = keyboard_check(vk_right) || keyboard_check(ord("D"));
var key_j_h     = keyboard_check(ord("J"));
var key_k_h     = keyboard_check(ord("K"));

if (gp) {
    var lx = gamepad_axis_value(0, gp_axislh);
    var ly = gamepad_axis_value(0, gp_axislv);
    if (ly < -dead) key_up_p    = true;
    if (ly >  dead) key_down_p  = true;
    if (lx < -dead) { key_left_p  = true; key_left_h  = true; }
    if (lx >  dead) { key_right_p = true; key_right_h = true; }
    if (gamepad_button_check_pressed(0, gp_face1)) key_space_p = true;  // A/Cross
    if (gamepad_button_check(0, gp_shoulderl))  key_j_h = true;   // LB/L1
    if (gamepad_button_check(0, gp_shoulderr))  key_k_h = true;   // RB/R1
}

// === COUNTDOWN TIMER ===
if (phase == 0 || phase == 1) {
    if (intro_timer > 0) {
        intro_timer--;
    } else {
        bomb_frames_left--;
        timer_red = (bomb_frames_left < 30 * 60);
        if (bomb_frames_left <= 0) {
            bomb_frames_left = 0;
            phase     = 3;
            end_timer = 0;
        }
    }
}

// === PHASE 0: ROPE PUZZLE ===
if (phase == 0 && intro_timer <= 0) {

    // Switch active strand
    if (key_up_p   && active_strand > 0) active_strand--;
    if (key_down_p && active_strand < 2) active_strand++;

    // Strand 0: mash SPACE — fills fast on press, decays slowly
    if (active_strand == 0 && !rope_done[0]) {
        if (key_space_p) {
            rope_progress[@ 0] = min(rope_progress[0] + 0.09, 1.0);
        }
        if (rope_progress[0] >= 1.0) rope_done[@ 0] = true;  // check before decay
        rope_progress[@ 0] = max(rope_progress[0] - 0.004, 0.0);
    }

    // Strand 1: alternate LEFT / RIGHT
    if (active_strand == 1 && !rope_done[1]) {
        if (key_right_p && strand1_expect == 1) {
            strand1_expect     = -1;
            rope_progress[@ 1] = min(rope_progress[1] + 0.055, 1.0);
        } else if (key_left_p && strand1_expect == -1) {
            strand1_expect     = 1;
            rope_progress[@ 1] = min(rope_progress[1] + 0.055, 1.0);
        }
        if (rope_progress[1] >= 1.0) rope_done[@ 1] = true;  // check before decay
        rope_progress[@ 1] = max(rope_progress[1] - 0.003, 0.0);
    }

    // Strand 2: hold J+K (or LB+RB) simultaneously
    if (active_strand == 2 && !rope_done[2]) {
        if (key_j_h && key_k_h) {
            strand2_hold++;
        } else {
            strand2_hold = max(strand2_hold - 4, 0);
        }
        rope_progress[@ 2] = clamp(strand2_hold / strand2_need, 0, 1);
        if (strand2_hold >= strand2_need) rope_done[@ 2] = true;
    }

    // All three strands broken → advance to bomb
    if (rope_done[0] && rope_done[1] && rope_done[2]) {
        phase            = 1;
        bomb_step        = 0;
        wire_selected    = 0;
        code_show_timer  = 180;
        code_hidden      = false;
        code_cursor      = 0;
        code_input       = [-1, -1, -1, -1];
        detonator_hold   = 0;
    }
}

// === PHASE 1: BOMB PUZZLE ===
if (phase == 1 && intro_timer <= 0) {

    // ---- Step 0: Wire Selection ----
    if (bomb_step == 0) {
        if (key_left_p  && wire_selected > 0) wire_selected--;
        if (key_right_p && wire_selected < 4) wire_selected++;
        if (key_space_p) {
            if (wire_selected == wire_correct) {
                bomb_step       = 1;
                code_show_timer = 180;
                code_hidden     = false;
            } else {
                phase     = 3;  // wrong wire = dead
                end_timer = 0;
            }
        }
    }

    // ---- Step 1: Code Entry ----
    if (bomb_step == 1) {
        if (code_show_timer > 0) {
            code_show_timer--;
            if (code_show_timer <= 0) code_hidden = true;
        }
        if (code_wrong_flash > 0) code_wrong_flash--;

        // Number key input (keyboard row 0–9)
        for (var _d = 0; _d <= 9; _d++) {
            if (keyboard_check_pressed(ord(string(_d))) && code_cursor < 4) {
                code_input[@ code_cursor] = _d;
                code_cursor++;
            }
        }
        // Backspace to erase last digit
        if (keyboard_check_pressed(vk_backspace) && code_cursor > 0) {
            code_cursor--;
            code_input[@ code_cursor] = -1;
        }

        // Confirm when 4 digits entered — SPACE or ENTER
        if (code_cursor == 4 && key_space_p) {
            var _match = true;
            for (var _ci = 0; _ci < 4; _ci++) {
                if (code_input[_ci] != code_digits[_ci]) { _match = false; break; }
            }
            if (_match) {
                bomb_step      = 2;
                detonator_hold = 0;
            } else {
                bomb_frames_left  = max(bomb_frames_left - 15 * 60, 0);
                code_wrong_flash  = 90;
                code_cursor       = 0;
                code_input        = [-1, -1, -1, -1];
                code_hidden       = false;
                code_show_timer   = 90;  // briefly re-show the code
            }
        }
    }

    // ---- Step 2: Pull the detonator — hold LEFT+RIGHT (or LB+RB) ----
    if (bomb_step == 2) {
        if (key_left_h && key_right_h) {
            detonator_hold++;
        } else {
            detonator_hold = max(detonator_hold - 2, 0);
        }
        if (detonator_hold >= detonator_need) {
            phase     = 2;
            end_timer = 0;
        }
    }
}

// === PHASE 2: WIN / NARRATIVE REVEAL ===
if (phase == 2) {
    end_timer++;
    slide_fade_in++;

    // First 3 seconds: just the DEFUSED flash — no input
    if (end_timer > 180 && narrative_slide < 8) {
        // SPACE or A or Enter advances to next slide
        if (key_space_p) {
            narrative_slide++;
            slide_fade_in = 0;
        }
    }

    // After final slide, auto-return to title after 4 seconds
    if (narrative_slide >= 8) {
        if (slide_fade_in >= 240) {
            global.game_state = 0;
            room_goto(Room5);  // Dan goes home — Level 5 begins
        }
    }
}

// === PHASE 3: DEAD ===
if (phase == 3) {
    end_timer++;
    var _restart = keyboard_check_pressed(ord("R"));
    if (!_restart && gp) {
        _restart = gamepad_button_check_pressed(0, gp_start)
                || gamepad_button_check_pressed(0, gp_face1);
    }
    if (end_timer > 90 && _restart) {
        global.game_state = 0;
        room_restart();
    }
}
