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

// ─── FAR CITY SILHOUETTE (middle distance) ───
draw_set_color(make_color_rgb(22, 18, 28));
for (var _fi = 0; _fi < 32; _fi++) {
    var _fx  = _fi * 65 - 15;
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
    var _nx = _ni * 130 - 50;
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
    var _rx = (_rb * 29) mod gw;
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
// MAIN MENU
// ═══════════════════════════════════════════════════════

    // Dark panel behind title
    draw_set_alpha(0.62);
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_rectangle(mid - 520, gh * 0.11, mid + 520, gh * 0.43, false);
    draw_set_alpha(1);

    // Amber rule lines
    draw_set_color(make_color_rgb(190, 130, 25));
    draw_rectangle(mid - 500, gh * 0.125, mid + 500, gh * 0.129, false);
    draw_rectangle(mid - 500, gh * 0.405, mid + 500, gh * 0.409, false);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Era text
    draw_set_color(make_color_rgb(150, 110, 35));
    draw_text_transformed(mid, gh * 0.175, "1  9  4  5   ·   C O M B A T   V E T E R A N", 0.82, 0.82, 0);

    // Title glow layers
    for (var _gl = 5; _gl >= 1; _gl--) {
        draw_set_alpha(0.10 / _gl);
        draw_set_color(make_color_rgb(255, 180, 0));
        draw_text_transformed(mid, gh * 0.285, "FOXHOLE  DAN", 4.4 + _gl * 0.4, 4.4 + _gl * 0.4, 0);
    }
    draw_set_alpha(1);

    // Title shadow
    draw_set_color(make_color_rgb(60, 20, 0));
    draw_text_transformed(mid + 6, gh * 0.285 + 6, "FOXHOLE  DAN", 4.4, 4.4, 0);

    // Title — bright amber pulse
    var _tp = 0.88 + sin(t * 1.5) * 0.12;
    draw_set_color(make_color_rgb(floor(230 * _tp + 22), floor(188 * _tp), floor(55 * _tp)));
    draw_text_transformed(mid, gh * 0.285, "FOXHOLE  DAN", 4.4, 4.4, 0);

    // Tagline
    draw_set_color(make_color_rgb(165, 142, 85));
    draw_text_transformed(mid, gh * 0.385, "He survived the war.  The war never left him.", 1.06, 1.06, 0);

    // Separator
    draw_set_color(make_color_rgb(80, 60, 20));
    draw_rectangle(mid - 200, gh * 0.46, mid + 200, gh * 0.462, false);

    // PLAY — big pulse
    var _pp = 0.72 + abs(sin(t * 1.9)) * 0.28;
    draw_set_alpha(_pp);
    draw_set_color(make_color_rgb(255, 235, 60));
    draw_text_transformed(mid, gh * 0.54, "SPACE  /  START  ──  PLAY", 1.50, 1.50, 0);
    draw_set_alpha(1);

    // Arrow brackets
    draw_set_color(make_color_rgb(210, 160, 35));
    draw_text_transformed(mid - 260, gh * 0.54, ">", 1.50, 1.50, 0);
    draw_text_transformed(mid + 260, gh * 0.54, "<", 1.50, 1.50, 0);

    // Controls link
    draw_set_color(make_color_rgb(120, 108, 62));
    draw_text_transformed(mid, gh * 0.635, "C  /  X  ──  CONTROLS", 1.10, 1.10, 0);

    // Mature content footer
    draw_set_color(make_color_rgb(90, 55, 35));
    draw_rectangle(mid - 400, gh * 0.845, mid + 400, gh * 0.847, false);
    draw_set_color(make_color_rgb(190, 95, 60));
    draw_text_transformed(mid, gh * 0.880, "MATURE CONTENT  ·  18+  ·  PTSD  ·  COMBAT  ·  VIOLENCE", 0.80, 0.80, 0);
    draw_set_color(make_color_rgb(100, 62, 42));
    draw_text_transformed(mid, gh * 0.935, "Not suitable for children.", 0.72, 0.72, 0);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

// ═══════════════════════════════════════════════════════
} else {
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
        ["MOVE",     "WASD  /  Arrow Keys",       "Left Stick"],
        ["JUMP",     "Space  /  W  /  Up",          "A  (Cross)"],
        ["SHOOT",    "J  /  Left Mouse",             "RT  /  RB"],
        ["AIM",      "WASD  /  Arrow Keys",          "Right Stick"],
        ["GRAPPLE",  "G",                            "Y  (Triangle)"],
        ["CROUCH",   "S  /  Down  (grounded)",       "L-Stick Down"],
        ["RESTART",  "R  (win / dead screen)",       "Start"],
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
}

draw_set_color(c_white);
draw_set_alpha(1);
