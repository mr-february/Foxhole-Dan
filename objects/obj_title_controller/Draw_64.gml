var gw  = display_get_gui_width();
var gh  = display_get_gui_height();
var mid = gw * 0.5;

// ── BACKGROUND ──
draw_set_alpha(1);
draw_set_color(make_color_rgb(6, 8, 4));
draw_rectangle(0, 0, gw, gh, false);

// Subtle military grain
for (var _gi = 0; _gi < 100; _gi++) {
    var _gx = (_gi * 137) mod gw;
    var _gy = (_gi * 89)  mod gh;
    draw_set_alpha(0.03 + (_gi mod 3) * 0.012);
    draw_set_color(make_color_rgb(38 + _gi mod 22, 50, 18));
    draw_rectangle(_gx, _gy, _gx + 3, _gy + 2, false);
}
draw_set_alpha(1);

// ─────────────────────────────────────────────────────────────────────────────
if (state == 0) {
// ─────────────────────────────────────────────────────────────────────────────
// MAIN MENU

    // Ruined skyline silhouette at bottom
    draw_set_color(make_color_rgb(10, 12, 6));
    for (var _si = 0; _si < 50; _si++) {
        var _sx = _si * 40;
        var _sh = 28 + (_si * 43) mod 52;
        draw_rectangle(_sx, gh - _sh, _sx + 37, gh, false);
    }

    // Stars
    draw_set_color(make_color_rgb(200, 205, 215));
    for (var _st = 0; _st < 65; _st++) {
        var _stx = (_st * 317) mod gw;
        var _sty = (_st * 211) mod (gh * 0.45);
        draw_set_alpha(0.28 + sin(current_time * 0.005 + _st) * 0.22);
        draw_circle(_stx, _sty, 1, false);
    }
    draw_set_alpha(1);

    // Horizontal rule lines
    draw_set_color(make_color_rgb(55, 70, 35));
    draw_rectangle(mid - 340, gh * 0.17, mid + 340, gh * 0.17 + 1, false);
    draw_rectangle(mid - 290, gh * 0.61, mid + 290, gh * 0.61 + 1, false);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Title drop-shadow
    draw_set_color(c_black);
    draw_set_alpha(0.55);
    draw_text_transformed(mid + 4, gh * 0.26 + 4, "FOXHOLE  DAN", 3.8, 3.8, 0);
    draw_set_alpha(1);

    // Title text
    draw_set_color(make_color_rgb(208, 196, 148));
    draw_text_transformed(mid, gh * 0.26, "FOXHOLE  DAN", 3.8, 3.8, 0);

    // Tagline
    draw_set_color(make_color_rgb(120, 110, 72));
    draw_text_transformed(mid, gh * 0.43, "A war veteran's unfinished battle.", 1.02, 1.02, 0);

    // PLAY option — pulse
    var _pulse = 0.68 + abs(sin(current_time * 0.006)) * 0.32;
    draw_set_alpha(_pulse);
    draw_set_color(make_color_rgb(200, 184, 96));
    draw_text_transformed(mid, gh * 0.555, "SPACE  /  START  —  NEW GAME", 1.28, 1.28, 0);
    draw_set_alpha(1);

    // CONTROLS option
    draw_set_color(make_color_rgb(108, 100, 64));
    draw_text_transformed(mid, gh * 0.648, "C  /  X  —  CONTROLS", 1.02, 1.02, 0);

    // Footer
    draw_set_color(make_color_rgb(65, 55, 35));
    draw_text_transformed(mid, gh * 0.90, "MATURE CONTENT  —  18+  —  Themes: PTSD  |  Combat  |  Violence", 0.76, 0.76, 0);
    draw_set_color(make_color_rgb(42, 42, 42));
    draw_text_transformed(mid, gh * 0.95, "Not for kids.", 0.70, 0.70, 0);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

// ─────────────────────────────────────────────────────────────────────────────
} else {
// ─────────────────────────────────────────────────────────────────────────────
// CONTROLS SCREEN

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Header
    draw_set_color(make_color_rgb(196, 180, 104));
    draw_text_transformed(mid, 44, "CONTROLS", 2.0, 2.0, 0);
    draw_set_color(make_color_rgb(65, 78, 38));
    draw_rectangle(100, 74, gw - 100, 76, false);

    // Column positions
    var _col_act = gw * 0.30;
    var _col_kb  = gw * 0.58;
    var _col_gp  = gw * 0.82;
    var _row0    = 108;
    var _rgap    = 54;

    // Column headers
    draw_set_color(make_color_rgb(148, 136, 84));
    draw_text_transformed(_col_act, _row0, "ACTION",   1.0, 1.0, 0);
    draw_text_transformed(_col_kb,  _row0, "KEYBOARD", 1.0, 1.0, 0);
    draw_text_transformed(_col_gp,  _row0, "GAMEPAD",  1.0, 1.0, 0);

    draw_set_color(make_color_rgb(50, 62, 28));
    draw_rectangle(80, _row0 + 20, gw - 80, _row0 + 22, false);

    // Action rows
    var _acts = [
        ["MOVE",       "WASD  /  Arrow Keys",       "Left Stick"],
        ["JUMP",       "Space  /  W  /  Up",         "A  (Cross)"],
        ["SHOOT",      "J  /  Left Mouse",            "RT  /  RB"],
        ["AIM",        "WASD  /  Arrow Keys",         "Right Stick"],
        ["CROUCH",     "S  /  Down  (on ground)",     "L-Stick Down  (on ground)"],
        ["RESTART",    "R",                            "Start  (win / dead screen)"],
    ];

    for (var _ai = 0; _ai < array_length(_acts); _ai++) {
        var _ry = _row0 + _rgap * (_ai + 1);

        // Alternating row tint
        draw_set_alpha(0.38);
        draw_set_color((_ai mod 2 == 0) ? make_color_rgb(22, 26, 14) : make_color_rgb(14, 18, 8));
        draw_rectangle(80, _ry - 20, gw - 80, _ry + 20, false);
        draw_set_alpha(1);

        draw_set_color(make_color_rgb(172, 158, 92));
        draw_text_transformed(_col_act, _ry, _acts[_ai][0], 0.92, 0.92, 0);

        draw_set_color(make_color_rgb(205, 195, 154));
        draw_text_transformed(_col_kb, _ry, _acts[_ai][1], 0.82, 0.82, 0);

        draw_set_color(make_color_rgb(124, 205, 124));
        draw_text_transformed(_col_gp, _ry, _acts[_ai][2], 0.82, 0.82, 0);
    }

    // Back prompt — pulse
    var _bp = 0.65 + abs(sin(current_time * 0.007)) * 0.35;
    draw_set_alpha(_bp);
    draw_set_color(make_color_rgb(155, 140, 75));
    draw_text_transformed(mid, gh - 42, "SPACE  /  A  /  ESC  —  BACK", 0.98, 0.98, 0);
    draw_set_alpha(1);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

draw_set_color(c_white);
draw_set_alpha(1);
