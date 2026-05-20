var gw = 1920;
var gh = 768;

// ============================================================
// PHASE 0: INTRO NARRATIVE
// ============================================================
if (phase == 0) {
    var _fa = clamp(slide_timer / 45.0, 0, 1);
    draw_set_color(c_black);
    draw_set_alpha(0.92);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(_fa);

    var _main  = "";
    var _sub   = "";
    var _sub2  = "";
    var _mcol  = c_white;

    switch (intro_slide) {
        case 0:
            _main = "Three days later.";
            _sub  = "Dan drove home in the dark, watching the mirrors.";
            break;
        case 1:
            _main = "The house was exactly as he'd left it.";
            _sub  = "Curtains open. Porch light on.";
            _sub2 = "Someone had been watching.";
            break;
        case 2:
            _main = "Reyes had his discharge papers.";
            _sub  = "His address. His habits. His schedule.";
            _sub2 = "He'd been planning this longer than the rooftop.";
            break;
        case 3:
            _main = "Dan thought about running.";
            _sub  = "";
            _sub2 = "He didn't.";
            break;
        case 4:
            _main  = "LAST STAND";
            _mcol  = make_color_rgb(220, 60, 60);
            _sub   = "Defend your home. All six waves. Then face Reyes.";
            _sub2  = "Press SPACE to begin.";
            break;
    }

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_mcol);
    draw_text_transformed(gw/2, gh/2 - 55, _main, 1.8, 1.8, 0);
    draw_set_color(make_color_rgb(180, 165, 110));
    draw_text_transformed(gw/2, gh/2 + 10, _sub, 1.05, 1.05, 0);
    draw_set_color(make_color_rgb(145, 132, 85));
    draw_text_transformed(gw/2, gh/2 + 50, _sub2, 1.0, 1.0, 0);
    if (slide_timer > 80 && intro_slide < 4) {
        draw_set_color(make_color_rgb(90, 80, 45));
        draw_text_transformed(gw/2, gh - 44, "SPACE to continue", 0.78, 0.78, 0);
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    exit;
}

// ============================================================
// PHASE 1: GAMEPLAY HUD
// ============================================================
if (phase == 1) {

    // ---------- Currency ----------
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_set_alpha(0.60);
    draw_rectangle(8, 8, 330, 62, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(200, 180, 60));
    draw_text_transformed(16, 12, "AMMO CACHE  " + string(currency), 1.1, 1.1, 0);

    // ---------- Wave indicator ----------
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_set_alpha(0.60);
    draw_rectangle(gw - 260, 8, gw - 8, 62, false);
    draw_set_alpha(1);
    var _wdisp = (wave < 6) ? ("WAVE " + string(wave + 1) + " / 6") : "FINAL WAVE";
    draw_set_color(make_color_rgb(160, 210, 255));
    draw_set_halign(fa_right);
    draw_text_transformed(gw - 16, 12, _wdisp, 1.1, 1.1, 0);
    draw_set_halign(fa_left);

    // ---------- Build phase countdown ----------
    if (wave_state == 0) {
        var _secs = ceil(wave_timer / 60);
        draw_set_color(make_color_rgb(0, 0, 0));
        draw_set_alpha(0.55);
        draw_rectangle(gw/2 - 200, 8, gw/2 + 200, 60, false);
        draw_set_alpha(1);
        draw_set_halign(fa_center);
        draw_set_color(make_color_rgb(80, 220, 80));
        draw_text_transformed(gw/2, 10, "BUILD PHASE — " + string(_secs) + "s", 1.1, 1.1, 0);
        draw_set_color(make_color_rgb(130, 120, 70));
        var _incoming = (wave < array_length(wave_counts)) ? wave_counts[wave] : 0;
        draw_text_transformed(gw/2, 38, string(_incoming) + " enemies incoming", 0.82, 0.82, 0);
        draw_set_halign(fa_left);
    }

    // ---------- Tower selection bar (bottom) ----------
    var _bar_y = gh - 72;
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_set_alpha(0.70);
    draw_rectangle(0, _bar_y - 4, gw, gh, false);
    draw_set_alpha(1);

    var _tower_labels = [
        "[1]  MG NEST      80",
        "[2]  ARTILLERY  180",
        "[3]  BARRICADE    40",
    ];
    var _tower_cols = [
        make_color_rgb(180, 155, 80),
        make_color_rgb(100, 140, 200),
        make_color_rgb(160, 130, 70),
    ];
    for (var _ti = 0; _ti < 3; _ti++) {
        var _tx = 80 + _ti * 380;
        var _is_sel = (_ti == selected_tower);
        if (_is_sel) {
            draw_set_color(make_color_rgb(60, 55, 25));
            draw_set_alpha(0.7);
            draw_rectangle(_tx - 20, _bar_y - 2, _tx + 310, gh - 4, false);
            draw_set_alpha(1);
            draw_set_color(make_color_rgb(200, 180, 70));
            draw_rectangle(_tx - 20, _bar_y - 2, _tx + 310, gh - 4, true);
        }
        draw_set_color(_is_sel ? make_color_rgb(255, 230, 80) : _tower_cols[_ti]);
        draw_text_transformed(_tx, _bar_y + 4, _tower_labels[_ti], 1.0, 1.0, 0);
        // Affordability check
        if (currency < tower_costs[_ti]) {
            draw_set_color(make_color_rgb(180, 50, 50));
            draw_text_transformed(_tx, _bar_y + 32, "  (not enough)", 0.75, 0.75, 0);
        }
    }
    draw_set_color(make_color_rgb(90, 80, 50));
    draw_text_transformed(1280, _bar_y + 4, "LClick place  |  RClick sell (half)", 0.85, 0.85, 0);

    // ---------- Tower placement preview at mouse ----------
    var _mx = mouse_x;
    var _my = mouse_y;
    // Convert from screen space (GUI) to world space — for Room5 view is 1:1 so same
    var _too_close_h = (point_distance(_mx, _my, 960, 380) < 100);
    var _on_edge2    = (_mx < 40 || _mx > 1880 || _my < 40 || _my > 728);
    var _cost2  = tower_costs[selected_tower];
    var _valid  = !_too_close_h && !_on_edge2 && currency >= _cost2;
    draw_set_color(_valid ? make_color_rgb(80, 220, 80) : make_color_rgb(220, 60, 60));
    draw_set_alpha(0.5);
    draw_circle(_mx, _my, 20, true);
    draw_set_alpha(1);
    if (selected_tower < 2) {
        var _preview_range = (selected_tower == 0) ? 200 : 340;
        draw_set_color(_valid ? make_color_rgb(80, 220, 80) : make_color_rgb(220, 60, 60));
        draw_set_alpha(0.12);
        draw_circle(_mx, _my, _preview_range, false);
        draw_set_alpha(0.20);
        draw_circle(_mx, _my, _preview_range, true);
        draw_set_alpha(1);
    }

    // ---------- Reyes warning overlay ----------
    if (reyes_warning_active) {
        var _wa = clamp(reyes_warning_timer / 45.0, 0, 1);
        draw_set_color(make_color_rgb(60, 0, 0));
        draw_set_alpha(0.72 * _wa);
        draw_rectangle(0, 0, gw, gh, false);
        draw_set_alpha(_wa);

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(220, 30, 30));
        draw_text_transformed(gw/2, gh/2 - 80, "REYES", 4.5, 4.5, 0);
        draw_set_color(c_white);
        draw_text_transformed(gw/2, gh/2 + 10, "He came alone for the last hundred metres.", 1.15, 1.15, 0);
        draw_set_color(make_color_rgb(160, 148, 90));
        draw_text_transformed(gw/2, gh/2 + 55, "The way he taught Dan. Deliberate. Patient.", 1.0, 1.0, 0);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_alpha(1);
    }
}

// ============================================================
// PHASE 3: WIN — FINAL NARRATIVE SLIDES
// ============================================================
if (phase == 3) {
    var _sfa = clamp(slide_fade_in / 45.0, 0, 1);
    draw_set_color(c_black);
    draw_set_alpha(0.92);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    // Cinematic letterbox
    draw_set_color(make_color_rgb(120, 95, 38));
    draw_set_alpha(0.35 * _sfa);
    draw_rectangle(0, 155, gw, 159, false);
    draw_rectangle(0, gh - 159, gw, gh - 155, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(_sfa);

    var _main  = "";
    var _sub   = "";
    var _sub2  = "";
    var _mcol  = c_white;
    var _scol  = make_color_rgb(165, 150, 95);

    if (narrative_slide == 0) {
        _main = "Reyes hit the ground.";
        _sub  = "The yard was quiet.";
        _sub2 = "For a moment, just wind through the trees.";
    }
    if (narrative_slide == 1) {
        _main = "Dan walked toward him.";
        _sub  = "Hands still. For the first time in years, hands still.";
    }
    if (narrative_slide == 2) {
        _main = "\"Why, Reyes?\"";
        _mcol = make_color_rgb(200, 200, 255);
        _sub  = "Reyes looked up. Almost smiled.";
        _sub2 = "\"You know why, Dan.\"";
        _scol = make_color_rgb(200, 180, 100);
    }
    if (narrative_slide == 3) {
        _main = "The village. 2004.";
        _mcol = make_color_rgb(220, 80, 80);
        _sub  = "The orders Dan gave. The ones they were told to forget.";
        _sub2 = "Reyes never did.";
    }
    if (narrative_slide == 4) {
        _main = "Dan had made the call.";
        _sub  = "Twelve civilians. One insurgent.";
        _sub2 = "He never lost sleep over it.";
    }
    if (narrative_slide == 5) {
        _main = "Reyes lost everything.";
        _mcol = make_color_rgb(220, 80, 80);
        _sub  = "His family had been in that village.";
        _sub2 = "He never told Dan. Until now.";
        _scol = make_color_rgb(200, 140, 140);
    }
    if (narrative_slide == 6) {
        _main = "\"You were just following orders.\"";
        _mcol = make_color_rgb(200, 200, 255);
        _sub  = "\"That's what they all say.\"";
        _sub2 = "And then Reyes was quiet.";
        _scol = make_color_rgb(165, 150, 95);
    }
    if (narrative_slide == 7) {
        _main = "He never got to say he was sorry.";
        _sub  = "Or that Reyes was right.";
    }
    if (narrative_slide == 8) {
        _main  = "FOXHOLE DAN";
        _mcol  = make_color_rgb(220, 200, 80);
        _sub   = "\"The difference between a hero and a war criminal";
        _sub2  = "is often just which side wins.\"";
        var _ret_a = clamp((slide_fade_in - 120) / 80.0, 0, 1);
        draw_set_color(make_color_rgb(80, 70, 40));
        draw_set_alpha(_ret_a * _sfa);
        draw_text_transformed(gw/2, gh/2 + 120, "Returning to main menu...", 0.80, 0.80, 0);
        draw_set_alpha(_sfa);
    }

    draw_set_color(_mcol);
    draw_text_transformed(gw/2, gh/2 - 55, _main, 1.7, 1.7, 0);
    draw_set_color(_scol);
    draw_text_transformed(gw/2, gh/2 + 16, _sub, 1.0, 1.0, 0);
    draw_text_transformed(gw/2, gh/2 + 54, _sub2, 1.0, 1.0, 0);

    if (narrative_slide < 8 && slide_fade_in > 60) {
        var _pp = abs(sin(current_time * 0.004)) * 0.55 + 0.3;
        draw_set_color(make_color_rgb(100, 90, 50));
        draw_set_alpha(_pp * _sfa);
        draw_text_transformed(gw/2, gh - 46, "SPACE to continue", 0.78, 0.78, 0);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
}

// ============================================================
// PHASE 4: LOSE
// ============================================================
if (phase == 4) {
    var _da = clamp(end_timer / 60.0, 0, 1);
    draw_set_color(make_color_rgb(60, 0, 0));
    draw_set_alpha(0.88 * _da);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(_da);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(220, 40, 40));
    draw_text_transformed(gw/2, gh/2 - 70, "OVERRUN", 3.5, 3.5, 0);
    draw_set_color(c_white);
    draw_text_transformed(gw/2, gh/2 + 10, "The last light in the windows went dark.", 1.15, 1.15, 0);
    draw_set_color(make_color_rgb(165, 120, 120));
    draw_text_transformed(gw/2, gh/2 + 58, "Reyes always did finish what he started.", 1.0, 1.0, 0);
    if (end_timer > 120) {
        draw_set_color(make_color_rgb(130, 100, 80));
        draw_text_transformed(gw/2, gh/2 + 115, "Press R (or Start) to try again", 0.85, 0.85, 0);
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
}

draw_set_color(c_white);
