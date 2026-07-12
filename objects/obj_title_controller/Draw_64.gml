var gw  = 1920;
var gh  = 768;
var mid = gw * 0.5;
var t   = current_time * 0.001;

// ═══════════════════════════════════════════════════════
// ANIMATED WAR PANORAMA BACKGROUND
// ═══════════════════════════════════════════════════════

// Sky gradient: deep navy at top → dark amber at horizon
var horizon_y = gh * 0.60;
var sky_steps = 20;
for (var _band = 0; _band < sky_steps; _band++) {
    var _frac = _band / sky_steps;
    var _y1   = gh * (_band / sky_steps);
    var _y2   = gh * ((_band + 1) / sky_steps);
    var _r    = floor(lerp(4,  55, _frac));
    var _g    = floor(lerp(6,  18, _frac));
    var _bb   = floor(lerp(22,  6, _frac));
    draw_set_color(make_color_rgb(_r, _g, _bb));
    draw_set_alpha(1);
    draw_rectangle(0, _y1, gw, _y2, false);
}

// Stars — twinkle
draw_set_color(make_color_rgb(215, 222, 255));
for (var _s = 0; _s < 90; _s++) {
    var _sx = (_s * 239 + 13) mod gw;
    var _sy = (_s * 173 + 29) mod (gh * 0.46);
    var _sa = clamp(0.35 + sin(t * 2.3 + _s * 1.1) * 0.45, 0, 1);
    draw_set_alpha(_sa);
    draw_circle(_sx, _sy, (_s mod 4 == 0) ? 1.5 : 1, false);
}
draw_set_alpha(1);

// Distant horizon fire glow
for (var _hg = 0; _hg < 10; _hg++) {
    var _hx  = gw * (0.04 + _hg * 0.10);
    var _hr  = 70 + (_hg * 53) mod 110;
    var _ha  = 0.07 + abs(sin(t * 0.8 + _hg * 1.4)) * 0.11;
    draw_set_alpha(_ha);
    draw_set_color(make_color_rgb(255, 70 + (_hg mod 4) * 18, 0));
    draw_ellipse(_hx - _hr, horizon_y - 28, _hx + _hr, horizon_y + 35, false);
}
draw_set_alpha(1);

// Parallax drift — layers sway at different rates, like a slow pan
var _par_far  = sin(t * 0.07) * 12;
var _par_near = sin(t * 0.07) * 28;

// ─── FAR CITY SILHOUETTE (middle distance) ───
draw_set_color(make_color_rgb(22, 18, 28));
for (var _fi = 0; _fi < 32; _fi++) {
    var _fx  = _fi * 65 - 15 + _par_far;
    var _fh  = 50 + (_fi * 71) mod 120;
    var _fw  = 42 + (_fi * 29) mod 50;
    draw_rectangle(_fx, horizon_y - _fh, _fx + _fw, horizon_y, false);
    if ((_fi mod 5) == 2) {
        draw_triangle(_fx + _fw - 10, horizon_y - _fh,
                      _fx + _fw + 10, horizon_y - _fh + 24,
                      _fx + _fw,      horizon_y - _fh, false);
    }
}

// ─── NEAR RUBBLE + BUILDINGS (foreground) ───
draw_set_color(make_color_rgb(10, 8, 14));
for (var _ni = 0; _ni < 16; _ni++) {
    var _nx = _ni * 130 - 50 + _par_near;
    var _nh = 100 + (_ni * 79) mod 160;
    var _nw = 80 + (_ni * 43) mod 80;
    draw_rectangle(_nx, horizon_y - _nh + 55, _nx + _nw, gh, false);
    // Lit windows flicker like fire
    for (var _wr = 0; _wr < 5; _wr++) {
        for (var _wc = 0; _wc < 3; _wc++) {
            var _lit = ((_ni * 7 + _wr * 5 + _wc * 3) mod 8 < 2);
            if (_lit) {
                var _wy   = (horizon_y - _nh + 75) + _wr * 30;
                var _wx   = _nx + 12 + _wc * 24;
                var _wflk = 0.35 + abs(sin(t * 3.2 + _ni * 1.7 + _wr * 0.9)) * 0.55;
                draw_set_alpha(_wflk);
                draw_set_color(make_color_rgb(255, 160 + (_ni mod 3) * 15, 40));
                draw_rectangle(_wx, _wy, _wx + 12, _wy + 16, false);
            }
        }
    }
}
draw_set_alpha(1);

// Ground / rubble
draw_set_color(make_color_rgb(8, 6, 12));
draw_rectangle(0, horizon_y + 25, gw, gh, false);
draw_set_color(make_color_rgb(24, 19, 30));
for (var _rb = 0; _rb < 70; _rb++) {
    var _rx = ((_rb * 29) mod gw) + _par_near * 1.3;
    var _rh = 3 + (_rb * 19) mod 18;
    draw_rectangle(_rx, horizon_y + 23 - _rh, _rx + 22, horizon_y + 28, false);
}

// ─── SEARCHLIGHTS ───
for (var _sl = 0; _sl < 3; _sl++) {
    var _slx  = gw * (0.15 + _sl * 0.35);
    var _sly  = gh - 8;
    var _sang = -80 + sin(t * 0.45 + _sl * 1.2) * 42;
    var _slen = 520;
    var _sex  = _slx + lengthdir_x(_slen, _sang);
    var _sey  = _sly + lengthdir_y(_slen, _sang);
    for (var _sw = -10; _sw <= 10; _sw += 2) {
        draw_set_alpha(lerp(0.07, 0.01, abs(_sw) / 10));
        draw_set_color(make_color_rgb(190, 210, 255));
        draw_line_width(_slx + _sw, _sly, _sex + _sw * 4, _sey, 1);
    }
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(240, 248, 255));
    draw_circle(_slx, _sly, 5, false);
}
draw_set_alpha(1);

// ─── TRACER ROUNDS ───
for (var _tr = 0; _tr < 8; _tr++) {
    var _trspd = 0.55 + _tr * 0.12;
    var _trp   = frac(t * _trspd + _tr * 0.13);
    var _trx   = (_tr mod 2 == 0) ? _trp * (gw + 80) - 40 : gw - _trp * (gw + 80) + 40;
    var _try   = horizon_y - 30 - (_tr * 37) mod 160;
    var _trlen = (_tr mod 2 == 0) ? 35 : -35;
    var _tra   = 0.55 + sin(t * 6 + _tr) * 0.35;
    draw_set_alpha(clamp(_tra, 0.1, 0.95));
    draw_set_color(make_color_rgb(255, 150, 50));
    draw_line_width(_trx, _try, _trx + _trlen, _try - 2, 2);
    draw_set_color(make_color_rgb(255, 230, 200));
    draw_line_width(_trx, _try, _trx + _trlen * 0.4, _try, 1);
}
draw_set_alpha(1);

// ─── EXPANDING EXPLOSION FLASHES ───
for (var _ep = 0; _ep < 5; _ep++) {
    var _ephase = frac(t * 0.22 + _ep * 0.20);
    if (_ephase < 0.55) {
        var _epx   = gw * (0.08 + _ep * 0.22);
        var _epy   = horizon_y - 15 - (_ep * 23) mod 60;
        var _eprad = _ephase * 55;
        var _epa   = (1.0 - _ephase / 0.55) * 0.6;
        draw_set_alpha(_epa);
        draw_set_color(make_color_rgb(255, 110 + floor(_ephase * 100), 0));
        draw_circle(_epx, _epy, _eprad, false);
        draw_set_alpha(_epa * 0.65);
        draw_set_color(make_color_rgb(255, 230, 120));
        draw_circle(_epx, _epy, _eprad * 0.45, false);
    }
}
draw_set_alpha(1);

// ═══════════════════════════════════════════════════════
if (state == 0) {
// MAIN MENU — SPACE goes to difficulty screen
// ═══════════════════════════════════════════════════════

    // Heavy dark panel — kills background noise behind all text
    draw_set_alpha(0.88);
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_rectangle(mid - 560, gh * 0.10, mid + 560, gh * 0.44, false);
    draw_set_alpha(1);

    // Gold rule lines bordering the panel
    draw_set_color(make_color_rgb(210, 150, 30));
    draw_rectangle(mid - 540, gh * 0.112, mid + 540, gh * 0.117, false);
    draw_rectangle(mid - 540, gh * 0.422, mid + 540, gh * 0.427, false);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Era text — brighter so it reads on the dark panel
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_text_transformed(mid + 2, gh * 0.158 + 2, "1  9  4  5   ·   C O M B A T   V E T E R A N", 0.84, 0.84, 0);
    draw_set_color(make_color_rgb(180, 145, 60));
    draw_text_transformed(mid, gh * 0.158, "1  9  4  5   ·   C O M B A T   V E T E R A N", 0.84, 0.84, 0);

    // Title glow halo
    for (var _gl = 5; _gl >= 1; _gl--) {
        draw_set_alpha(0.18 / _gl);
        draw_set_color(make_color_rgb(255, 200, 50));
        draw_text_transformed(mid, gh * 0.285, "FOXHOLE  DAN", 4.6 + _gl * 0.5, 4.6 + _gl * 0.5, 0);
    }
    draw_set_alpha(1);

    // Title — thick black shadow first (4 directions for outline effect)
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_text_transformed(mid - 5, gh * 0.285,     "FOXHOLE  DAN", 4.6, 4.6, 0);
    draw_text_transformed(mid + 5, gh * 0.285,     "FOXHOLE  DAN", 4.6, 4.6, 0);
    draw_text_transformed(mid,     gh * 0.285 - 5, "FOXHOLE  DAN", 4.6, 4.6, 0);
    draw_text_transformed(mid,     gh * 0.285 + 5, "FOXHOLE  DAN", 4.6, 4.6, 0);

    // Title — near-white with warm tint, pulsing slightly
    var _tp = 0.92 + sin(t * 1.5) * 0.08;
    draw_set_color(make_color_rgb(255, floor(240 * _tp), floor(160 * _tp)));
    draw_text_transformed(mid, gh * 0.285, "FOXHOLE  DAN", 4.6, 4.6, 0);

    // Tagline — white with shadow
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_text_transformed(mid + 2, gh * 0.388 + 2, "He survived the war.  The war never left him.", 1.08, 1.08, 0);
    draw_set_color(make_color_rgb(220, 205, 155));
    draw_text_transformed(mid, gh * 0.388, "He survived the war.  The war never left him.", 1.08, 1.08, 0);

    // Separator
    draw_set_color(make_color_rgb(100, 75, 25));
    draw_rectangle(mid - 220, gh * 0.465, mid + 220, gh * 0.467, false);

    // High score (shown only when a run has been completed)
    if (global.high_score > 0) {
        draw_set_alpha(0.72);
        draw_set_color(make_color_rgb(180, 162, 62));
        draw_text_transformed(mid, gh * 0.478, "BEST  " + string(global.high_score), 0.80, 0.80, 0);
        draw_set_alpha(1);
    }

    // Lighter semi-dark strip behind PLAY, CONTROLS, SETTINGS, LEADERBOARD
    draw_set_alpha(0.70);
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_rectangle(mid - 420, gh * 0.488, mid + 420, gh * 0.815, false);
    draw_set_alpha(1);

    // PLAY — shadow then bright white/yellow, pulsing
    var _pp = 0.78 + abs(sin(t * 1.9)) * 0.22;
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_text_transformed(mid + 3, gh * 0.525 + 3, "SPACE  /  START  ──  PLAY", 1.55, 1.55, 0);
    draw_set_alpha(_pp);
    draw_set_color(make_color_rgb(255, 245, 80));
    draw_text_transformed(mid, gh * 0.525, "SPACE  /  START  ──  PLAY", 1.55, 1.55, 0);
    draw_set_alpha(1);

    // Arrow brackets
    draw_set_color(make_color_rgb(255, 200, 40));
    draw_text_transformed(mid - 285, gh * 0.525, ">", 1.55, 1.55, 0);
    draw_text_transformed(mid + 285, gh * 0.525, "<", 1.55, 1.55, 0);

    // Controls link — shadow then bright
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_text_transformed(mid + 2, gh * 0.607 + 2, "C  /  X  ──  CONTROLS", 1.12, 1.12, 0);
    draw_set_color(make_color_rgb(190, 175, 110));
    draw_text_transformed(mid, gh * 0.607, "C  /  X  ──  CONTROLS", 1.12, 1.12, 0);

    // Settings link
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_text_transformed(mid + 2, gh * 0.690 + 2, "O  ──  SETTINGS", 1.12, 1.12, 0);
    draw_set_color(make_color_rgb(155, 175, 205));
    draw_text_transformed(mid, gh * 0.690, "O  ──  SETTINGS", 1.12, 1.12, 0);

    // Leaderboard link
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_text_transformed(mid + 2, gh * 0.773 + 2, "L  ──  LEADERBOARD", 1.12, 1.12, 0);
    draw_set_color(make_color_rgb(100, 200, 140));
    draw_text_transformed(mid, gh * 0.773, "L  ──  LEADERBOARD", 1.12, 1.12, 0);

    // ENDLESS SURVIVAL — shown once unlocked by beating the story.
    if (endless_unlocked) {
        draw_set_color(make_color_rgb(0, 0, 0));
        draw_text_transformed(mid + 2, gh * 0.70 + 2, "E  /  RB  ──  ENDLESS SURVIVAL", 1.12, 1.12, 0);
        draw_set_color(make_color_rgb(230, 180, 60));
        draw_text_transformed(mid, gh * 0.70, "E  /  RB  ──  ENDLESS SURVIVAL", 1.12, 1.12, 0);
        if (endless_best > 0) {
            draw_set_color(make_color_rgb(150, 150, 160));
            draw_text_transformed(mid, gh * 0.735, "ENDLESS BEST  " + string(endless_best), 0.72, 0.72, 0);
        }
    }

    // Mature content footer — dark strip then readable text
    draw_set_alpha(0.65);
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_rectangle(0, gh * 0.840, gw, gh, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(210, 110, 70));
    draw_text_transformed(mid, gh * 0.878, "MATURE CONTENT  ·  18+  ·  PTSD  ·  COMBAT  ·  VIOLENCE", 0.82, 0.82, 0);
    draw_set_color(make_color_rgb(140, 85, 60));
    draw_text_transformed(mid, gh * 0.936, "Not suitable for children.", 0.74, 0.74, 0);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

// ═══════════════════════════════════════════════════════
} else if (state == 1) {
// CONTROLS SCREEN
// ═══════════════════════════════════════════════════════

    // Darkened overlay over panorama
    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(3, 3, 8));
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(make_color_rgb(230, 198, 75));
    draw_text_transformed(mid, 50, "CONTROLS", 2.2, 2.2, 0);
    draw_set_color(make_color_rgb(150, 115, 28));
    draw_rectangle(80, 84, gw - 80, 87, false);

    var _ca = gw * 0.28;
    var _ck = gw * 0.57;
    var _cg = gw * 0.82;
    var _r0 = 122;
    var _rg = 58;

    draw_set_color(make_color_rgb(165, 145, 65));
    draw_text_transformed(_ca, _r0, "ACTION",   1.0, 1.0, 0);
    draw_text_transformed(_ck, _r0, "KEYBOARD", 1.0, 1.0, 0);
    draw_text_transformed(_cg, _r0, "GAMEPAD",  1.0, 1.0, 0);
    draw_set_color(make_color_rgb(75, 58, 20));
    draw_rectangle(80, _r0 + 22, gw - 80, _r0 + 25, false);

    var _rows = [
        ["MOVE",        "WASD  /  Arrow Keys",        "Left Stick"],
        ["JUMP",        "Space  /  W  /  Up",          "A  (Cross)"],
        ["SHOOT",       "J  /  Left Mouse",             "RT  /  RB"],
        ["AIM",         "WASD  /  Arrow Keys",          "Right Stick"],
        ["GRENADE",     "K",                            "LB  (L1)"],
        ["DODGE ROLL",  "Shift",                        "L3"],
        ["GRAPPLE",     "G",                            "Y  (Triangle)"],
        ["CROUCH",      "S  /  Down  (grounded)",       "L-Stick Down"],
        ["RESTART",     "R  (win / dead screen)",       "Start"],
    ];

    for (var _ri = 0; _ri < array_length(_rows); _ri++) {
        var _ry = _r0 + _rg * (_ri + 1);
        draw_set_alpha(0.48);
        draw_set_color((_ri mod 2 == 0) ? make_color_rgb(28, 26, 12) : make_color_rgb(16, 14, 6));
        draw_rectangle(80, _ry - 22, gw - 80, _ry + 22, false);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(215, 190, 85));
        draw_text_transformed(_ca, _ry, _rows[_ri][0], 0.96, 0.96, 0);
        draw_set_color(make_color_rgb(225, 215, 172));
        draw_text_transformed(_ck, _ry, _rows[_ri][1], 0.85, 0.85, 0);
        draw_set_color(make_color_rgb(95, 225, 120));
        draw_text_transformed(_cg, _ry, _rows[_ri][2], 0.85, 0.85, 0);
    }

    var _bp = 0.62 + abs(sin(t * 1.9)) * 0.38;
    draw_set_alpha(_bp);
    draw_set_color(make_color_rgb(185, 158, 68));
    draw_text_transformed(mid, gh - 38, "SPACE  /  A  /  ESC  ──  BACK", 1.02, 1.02, 0);
    draw_set_alpha(1);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

// ═══════════════════════════════════════════════════════
} else if (state == 2) {
// DIFFICULTY SELECT SCREEN
// ═══════════════════════════════════════════════════════

    // Dark overlay over panorama
    draw_set_alpha(0.84);
    draw_set_color(make_color_rgb(2, 2, 6));
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Title
    draw_set_color(make_color_rgb(230, 198, 75));
    draw_text_transformed(mid, 50, "SELECT DIFFICULTY", 2.0, 2.0, 0);
    draw_set_color(make_color_rgb(150, 115, 28));
    draw_rectangle(80, 82, gw - 80, 85, false);

    var _diff_names = ["EASY",   "NORMAL",  "HARD",     "BRUTAL"];
    var _diff_subs  = [
        "For story — enemies slower, less HP, more time",
        "The intended experience — gritty and fair",
        "Unforgiving — enemies hit hard and throw grenades often",
        "Hell — one bad engagement can end the run"
    ];
    var _diff_cols  = [
        make_color_rgb(80,  200, 80),
        make_color_rgb(220, 200, 60),
        make_color_rgb(230, 120, 40),
        make_color_rgb(220, 40,  40)
    ];

    var _panel_x  = mid - 460;
    var _panel_w  = 920;
    var _row_h    = 112;
    var _start_y  = 130;

    for (var _di = 0; _di < 4; _di++) {
        var _ry = _start_y + _di * _row_h;
        var _sel = (_di == diff_sel);

        // Row background
        draw_set_alpha(_sel ? 0.70 : 0.32);
        draw_set_color(_sel ? make_color_rgb(18, 16, 8) : make_color_rgb(10, 8, 4));
        draw_rectangle(_panel_x, _ry, _panel_x + _panel_w, _ry + _row_h - 6, false);
        draw_set_alpha(1);

        // Selected border glow
        if (_sel) {
            draw_set_color(_diff_cols[_di]);
            draw_rectangle(_panel_x, _ry, _panel_x + _panel_w, _ry + _row_h - 6, true);
            draw_set_color(_diff_cols[_di]);
            draw_text_transformed(_panel_x - 28, _ry + _row_h * 0.44, ">", 1.6, 1.6, 0);
            draw_text_transformed(_panel_x + _panel_w + 28, _ry + _row_h * 0.44, "<", 1.6, 1.6, 0);
        }

        // Difficulty name
        var _name_scale = _sel ? 1.55 : 1.22;
        draw_set_alpha(_sel ? 1.0 : 0.55);
        draw_set_color(_diff_cols[_di]);
        draw_text_transformed(mid, _ry + _row_h * 0.32, _diff_names[_di], _name_scale, _name_scale, 0);

        // Subtitle
        draw_set_alpha(_sel ? 0.88 : 0.38);
        draw_set_color(make_color_rgb(210, 195, 145));
        draw_text_transformed(mid, _ry + _row_h * 0.70, _diff_subs[_di], 0.82, 0.82, 0);
        draw_set_alpha(1);
    }

    // Bottom hint — pulsing
    var _bp2 = 0.62 + abs(sin(t * 1.9)) * 0.38;
    draw_set_alpha(_bp2);
    draw_set_color(make_color_rgb(185, 158, 68));
    draw_text_transformed(mid, gh - 38, "W / S  /  D-Pad  ──  SELECT       SPACE / A  ──  CONFIRM       ESC / B  ──  BACK", 0.90, 0.90, 0);
    draw_set_alpha(1);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

// ═══════════════════════════════════════════════════════
} else if (state == 3) {
// SETTINGS SCREEN
// ═══════════════════════════════════════════════════════

    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(3, 3, 8));
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(make_color_rgb(230, 198, 75));
    draw_text_transformed(mid, 50, "SETTINGS", 2.2, 2.2, 0);
    draw_set_color(make_color_rgb(150, 115, 28));
    draw_rectangle(80, 84, gw - 80, 87, false);

    draw_set_color(make_color_rgb(195, 178, 100));
    draw_text_transformed(mid, 135, "AUDIO", 1.25, 1.25, 0);
    draw_set_color(make_color_rgb(60, 48, 16));
    draw_rectangle(mid - 260, 158, mid + 260, 161, false);

    var _sw     = 420;
    var _sh     = 22;
    var _labels = ["MUSIC", "SFX"];
    var _vals   = [global.vol_music, global.vol_sfx];

    for (var _si = 0; _si < 2; _si++) {
        var _sy   = 210 + _si * 130;
        var _ssel = (_si == settings_sel);
        var _sx   = mid - _sw * 0.5;

        draw_set_alpha(_ssel ? 1.0 : 0.48);
        draw_set_color(_ssel ? make_color_rgb(230, 208, 88) : make_color_rgb(155, 138, 72));
        draw_text_transformed(_sx - 120, _sy + 4, _labels[_si], _ssel ? 1.2 : 1.0, _ssel ? 1.2 : 1.0, 0);

        draw_set_color(make_color_rgb(22, 18, 10));
        draw_rectangle(_sx, _sy, _sx + _sw, _sy + _sh, false);
        draw_set_color(_ssel ? make_color_rgb(215, 175, 38) : make_color_rgb(108, 90, 22));
        draw_rectangle(_sx, _sy, _sx + _sw * _vals[_si], _sy + _sh, false);
        draw_set_color(_ssel ? make_color_rgb(222, 198, 70) : make_color_rgb(78, 65, 20));
        draw_rectangle(_sx, _sy, _sx + _sw, _sy + _sh, true);

        draw_set_halign(fa_left);
        draw_set_color(_ssel ? c_white : make_color_rgb(162, 148, 108));
        draw_text_transformed(_sx + _sw + 20, _sy + 2, string(floor(_vals[_si] * 100)) + "%", 0.96, 0.96, 0);
        draw_set_halign(fa_center);

        if (_ssel) {
            draw_set_alpha(0.9);
            draw_set_color(make_color_rgb(230, 208, 88));
            draw_text_transformed(_sx - 26, _sy + 10, "<", 1.5, 1.5, 0);
            draw_text_transformed(_sx + _sw + 86, _sy + 10, ">", 1.5, 1.5, 0);
        }
        draw_set_alpha(1);
    }

    var _bp3 = 0.62 + abs(sin(t * 1.9)) * 0.38;
    draw_set_alpha(_bp3);
    draw_set_color(make_color_rgb(185, 158, 68));
    draw_text_transformed(mid, gh - 38, "W / S  ──  SELECT       ← / →  ──  ADJUST       ESC  ──  BACK", 0.90, 0.90, 0);
    draw_set_alpha(1);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

// ═══════════════════════════════════════════════════════
} else if (state == 4) {
// LEADERBOARD SCREEN
// ═══════════════════════════════════════════════════════

    draw_set_alpha(0.86);
    draw_set_color(make_color_rgb(2, 2, 6));
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(make_color_rgb(230, 198, 75));
    draw_text_transformed(mid, 50, "LEADERBOARD", 2.2, 2.2, 0);
    draw_set_color(make_color_rgb(150, 115, 28));
    draw_rectangle(80, 84, gw - 80, 87, false);

    if (array_length(lb_scores) == 0) {
        draw_set_color(make_color_rgb(160, 150, 110));
        draw_text_transformed(mid, gh / 2, "NO SCORES YET  —  BE THE FIRST", 1.1, 1.1, 0);
    } else {
        var _row_h    = 56;
        var _start_y  = 130;
        var _col_rank = mid - 380;
        var _col_name = mid - 220;
        var _col_scr  = mid + 340;

        draw_set_alpha(0.50);
        draw_set_color(make_color_rgb(180, 155, 60));
        draw_set_halign(fa_left);
        draw_text_transformed(_col_rank, _start_y, "#",     0.84, 0.84, 0);
        draw_text_transformed(_col_name, _start_y, "NAME",  0.84, 0.84, 0);
        draw_set_halign(fa_right);
        draw_text_transformed(_col_scr,  _start_y, "SCORE", 0.84, 0.84, 0);
        draw_set_alpha(1);

        var _medal_cols = [make_color_rgb(255, 215, 0), make_color_rgb(192, 192, 192), make_color_rgb(205, 127, 50)];
        for (var _ri = 0; _ri < array_length(lb_scores); _ri++) {
            var _ry    = _start_y + _row_h * (_ri + 1);
            var _entry = lb_scores[_ri];
            var _col   = (_ri < 3) ? _medal_cols[_ri] : make_color_rgb(185, 172, 140);

            draw_set_alpha((_ri < 3) ? 0.22 : 0.10);
            draw_set_color(make_color_rgb(30, 28, 18));
            draw_rectangle(mid - 420, _ry - 22, mid + 420, _ry + 22, false);
            draw_set_alpha(1);

            draw_set_color(_col);
            draw_set_halign(fa_left);
            draw_text_transformed(_col_rank, _ry, string(_ri + 1) + ".", 0.94, 0.94, 0);
            draw_text_transformed(_col_name, _ry, string(_entry.name),   0.94, 0.94, 0);
            draw_set_halign(fa_right);
            draw_text_transformed(_col_scr,  _ry, string(_entry.score),  0.94, 0.94, 0);
        }
        draw_set_halign(fa_center);
    }

    var _bp4 = 0.62 + abs(sin(t * 1.9)) * 0.38;
    draw_set_alpha(_bp4);
    draw_set_color(make_color_rgb(185, 158, 68));
    draw_text_transformed(mid, gh - 38, "SPACE  /  ESC  ──  BACK", 0.90, 0.90, 0);
    draw_set_alpha(1);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

// ═══════════════════════════════════════════════════════
} else if (state == 5) {
// NAME ENTRY — after completing a run
// ═══════════════════════════════════════════════════════

    draw_set_alpha(0.90);
    draw_set_color(make_color_rgb(2, 2, 6));
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(make_color_rgb(230, 198, 75));
    draw_text_transformed(mid, gh * 0.20, "MISSION  COMPLETE", 2.0, 2.0, 0);

    draw_set_color(make_color_rgb(185, 172, 110));
    draw_text_transformed(mid, gh * 0.35, "FINAL  SCORE  ──  " + string(global.pending_score), 1.4, 1.4, 0);

    var _tot_sec = floor(global.pending_time / room_speed);
    var _mm      = string(floor(_tot_sec / 60));
    var _ss      = string(_tot_sec mod 60);
    if (string_length(_ss) < 2) _ss = "0" + _ss;
    draw_set_color(make_color_rgb(150, 160, 175));
    draw_text_transformed(mid, gh * 0.40,
        "TIME  " + _mm + ":" + _ss + "    KILLS  " + string(global.pending_kills) + "    DEATHS  " + string(global.pending_deaths),
        0.92, 0.92, 0);
    if (global.pending_is_best) {
        var _bp5 = 0.6 + abs(sin(t * 2.4)) * 0.4;
        draw_set_alpha(_bp5);
        draw_set_color(make_color_rgb(120, 220, 140));
        draw_text_transformed(mid, gh * 0.44, "★  NEW BEST TIME  ★", 0.95, 0.95, 0);
        draw_set_alpha(1);
    }

    draw_set_color(make_color_rgb(90, 70, 22));
    draw_rectangle(mid - 280, gh * 0.470, mid + 280, gh * 0.473, false);

    draw_set_color(make_color_rgb(155, 143, 96));
    draw_text_transformed(mid, gh * 0.515, "ENTER  YOUR  NAME  :", 1.05, 1.05, 0);

    // Name entry box
    var _bx = mid - 220;
    var _by = gh * 0.585;
    draw_set_color(make_color_rgb(18, 16, 10));
    draw_rectangle(_bx - 14, _by - 30, _bx + 454, _by + 34, false);
    draw_set_color(make_color_rgb(120, 100, 42));
    draw_rectangle(_bx - 14, _by - 30, _bx + 454, _by + 34, true);

    var _cursor = ((current_time mod 900) < 450) ? "_" : " ";
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text_transformed(_bx, _by, lb_name + _cursor, 1.22, 1.22, 0);
    draw_set_halign(fa_center);

    var _bpa = 0.62 + abs(sin(t * 1.9)) * 0.38;
    draw_set_alpha(_bpa);
    draw_set_color(make_color_rgb(210, 195, 75));
    draw_text_transformed(mid, gh * 0.720, "ENTER  ──  SUBMIT  TO  LEADERBOARD", 1.0, 1.0, 0);
    draw_set_color(make_color_rgb(130, 120, 90));
    draw_text_transformed(mid, gh * 0.785, "ESC  ──  SKIP", 0.88, 0.88, 0);
    draw_set_alpha(1);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

draw_set_color(c_white);
draw_set_alpha(1);
