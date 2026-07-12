var gw = 1920;
var gh = 768;
var _t = current_time * 0.001;

// ============================================================
// BACKGROUND: Night rooftop
// ============================================================

// Sky gradient — deep blue-black
var sky_top = make_color_rgb(5, 8, 22);
var sky_bot = make_color_rgb(18, 24, 48);
draw_rectangle_color(0, 0, gw, 500, sky_top, sky_top, sky_bot, sky_bot, false);

// Stars
randomize();
var _seed_save = random_get_seed();
random_set_seed(42);
for (var _s = 0; _s < 120; _s++) {
    var _sx = random(gw);
    var _sy = random(420);
    var _sa = 0.4 + 0.5 * sin(_t * 1.7 + _s);
    draw_set_color(c_white);
    draw_set_alpha(_sa);
    draw_point(_sx, _sy);
}
draw_set_alpha(1);
random_set_seed(_seed_save);

// Distant lightning — triple-sine product creates pseudo-random irregular flashes
var _lf = sin(_t * 0.31) * sin(_t * 0.73) * sin(_t * 0.17);
if (_lf > 0.82) {
    draw_set_alpha(min((_lf - 0.82) / 0.18 * 0.50, 0.50));
    draw_set_color(make_color_rgb(160, 190, 255));
    draw_rectangle(0, 290, gw, 490, false);
    draw_set_alpha(1);
}

// Distant city glow on horizon
draw_set_color(make_color_rgb(255, 120, 40));
draw_set_alpha(0.18);
draw_rectangle(0, 420, gw, 480, false);
draw_set_alpha(0.08);
draw_rectangle(0, 400, gw, 420, false);
draw_set_alpha(1);

// City silhouette blocks
var _buildings = [
    [0, 400, 80, 480],
    [60, 380, 140, 480],
    [130, 395, 220, 480],
    [200, 370, 290, 480],
    [270, 390, 360, 480],
    [340, 360, 440, 480],
    [420, 382, 510, 480],
    [490, 355, 600, 480],
    [580, 375, 680, 480],
    [650, 345, 760, 480],
    [740, 368, 850, 480],
    [820, 352, 940, 480],
    [910, 378, 1010, 480],
    [980, 342, 1090, 480],
    [1060, 362, 1170, 480],
    [1140, 370, 1240, 480],
    [1210, 348, 1330, 480],
    [1300, 368, 1410, 480],
    [1380, 355, 1490, 480],
    [1460, 372, 1570, 480],
    [1540, 360, 1660, 480],
    [1630, 378, 1740, 480],
    [1710, 350, 1830, 480],
    [1800, 365, 1920, 480],
];
draw_set_color(make_color_rgb(12, 14, 20));
for (var _b = 0; _b < array_length(_buildings); _b++) {
    draw_rectangle(_buildings[_b][0], _buildings[_b][1], _buildings[_b][2], _buildings[_b][3], false);
}

// Rooftop surface
draw_set_color(make_color_rgb(42, 44, 50));
draw_rectangle(0, 480, gw, gh, false);
draw_set_color(make_color_rgb(55, 58, 66));
draw_rectangle(0, 480, gw, 494, false);  // edge highlight
// Rooftop seam lines
draw_set_color(make_color_rgb(35, 37, 43));
for (var _rx = 0; _rx < gw; _rx += 96) {
    draw_line(_rx, 494, _rx, gh);
}
for (var _ry = 510; _ry < gh; _ry += 64) {
    draw_line(0, _ry, gw, _ry);
}

// Ventilation units (atmosphere)
draw_set_color(make_color_rgb(60, 62, 70));
draw_rectangle(1700, 430, 1800, 480, false);
draw_set_color(make_color_rgb(50, 52, 60));
draw_rectangle(1720, 408, 1780, 432, false);
draw_set_color(make_color_rgb(60, 62, 70));
draw_rectangle(100, 440, 200, 480, false);

// Railing along rooftop edge
draw_set_color(make_color_rgb(70, 72, 82));
draw_rectangle(0, 478, gw, 484, false);
for (var _rp = 0; _rp < gw; _rp += 48) {
    draw_rectangle(_rp, 460, _rp + 4, 480, false);
}

// Rain streaks over rooftop
draw_set_color(make_color_rgb(140, 168, 210));
for (var _ri4 = 0; _ri4 < 80; _ri4++) {
    var _rx4 = (_ri4 * 317 + 50) mod (gw + 60);
    var _ry4 = ((_t * 360 + _ri4 * 151) mod (gh + 60)) - 20;
    var _rl4 = 12 + (_ri4 mod 10);
    draw_set_alpha(0.07 + (_ri4 mod 4) * 0.035);
    draw_line_width(_rx4, _ry4, _rx4 - 3, _ry4 + _rl4, 1);
}
draw_set_alpha(1);

// ============================================================
// DAN IN CHAIR (left side, x~380, y~560)
// ============================================================
var _cx = 380;
var _cy = 560;

// Chair legs
draw_set_color(make_color_rgb(60, 42, 26));
draw_rectangle(_cx - 28, _cy + 60, _cx - 22, _cy + 100, false);
draw_rectangle(_cx + 22, _cy + 60, _cx + 28, _cy + 100, false);
draw_rectangle(_cx - 28, _cy + 20, _cx - 22, _cy + 70, false);
draw_rectangle(_cx + 22, _cy + 20, _cx + 28, _cy + 70, false);
// Crossbar
draw_set_color(make_color_rgb(46, 32, 18));
draw_rectangle(_cx - 26, _cy + 78, _cx + 26, _cy + 83, false);
// Seat with wood grain
draw_set_color(make_color_rgb(90, 68, 44));
draw_rectangle(_cx - 32, _cy + 55, _cx + 32, _cy + 68, false);
draw_set_color(make_color_rgb(78, 58, 36));
draw_rectangle(_cx - 30, _cy + 58, _cx - 12, _cy + 60, false);
draw_rectangle(_cx - 2,  _cy + 58, _cx + 14, _cy + 60, false);
// Chair back frame
draw_set_color(make_color_rgb(90, 68, 44));
draw_rectangle(_cx - 32, _cy - 40, _cx - 26, _cy + 58, false);
draw_rectangle(_cx + 26, _cy - 40, _cx + 32, _cy + 58, false);
draw_rectangle(_cx - 32, _cy - 44, _cx + 32, _cy - 38, false);
// Chair slats
draw_set_color(make_color_rgb(78, 58, 36));
for (var _sl = 0; _sl < 4; _sl++) {
    draw_rectangle(_cx - 30, _cy - 32 + _sl * 16, _cx + 30, _cy - 29 + _sl * 16, false);
}

// Boots
draw_set_color(make_color_rgb(34, 26, 16));
draw_rectangle(_cx - 22, _cy + 87, _cx - 3,  _cy + 103, false);
draw_rectangle(_cx + 3,  _cy + 87, _cx + 22, _cy + 103, false);
draw_set_color(make_color_rgb(22, 16, 8));
draw_rectangle(_cx - 22, _cy + 100, _cx - 3,  _cy + 103, false);
draw_rectangle(_cx + 3,  _cy + 100, _cx + 22, _cy + 103, false);

// Trousers
draw_set_color(make_color_rgb(65, 78, 50));
draw_rectangle(_cx - 20, _cy + 54, _cx - 3,  _cy + 89, false);
draw_rectangle(_cx + 3,  _cy + 54, _cx + 20, _cy + 89, false);
draw_set_color(make_color_rgb(52, 62, 40));
draw_line(_cx - 12, _cy + 57, _cx - 12, _cy + 88);
draw_line(_cx + 12, _cy + 57, _cx + 12, _cy + 88);

// Jacket / torso
draw_set_color(make_color_rgb(70, 86, 60));
draw_rectangle(_cx - 20, _cy - 8, _cx + 20, _cy + 56, false);
// Collar shadow
draw_set_color(make_color_rgb(50, 62, 42));
draw_rectangle(_cx - 10, _cy - 8, _cx + 10, _cy + 6, false);
// Chest pockets
draw_set_color(make_color_rgb(58, 72, 48));
draw_rectangle(_cx - 18, _cy + 8,  _cx - 5, _cy + 24, false);
draw_rectangle(_cx + 5,  _cy + 8,  _cx + 18, _cy + 24, false);
draw_set_color(make_color_rgb(48, 60, 40));
draw_rectangle(_cx - 18, _cy + 8, _cx - 5,  _cy + 10, false);
draw_rectangle(_cx + 5,  _cy + 8, _cx + 18, _cy + 10, false);

// Dog tags (silver chain at neck)
draw_set_color(make_color_rgb(175, 175, 182));
draw_set_alpha(0.70);
draw_line_width(_cx - 2, _cy + 4, _cx - 2, _cy + 22, 1);
draw_rectangle(_cx - 6, _cy + 20, _cx + 2, _cy + 28, false);
draw_set_alpha(1);

// Arms on armrests
draw_set_color(make_color_rgb(70, 86, 60));
draw_rectangle(_cx - 36, _cy + 10, _cx - 20, _cy + 38, false);
draw_rectangle(_cx + 20, _cy + 10, _cx + 36, _cy + 38, false);
// Hands
draw_set_color(make_color_rgb(185, 152, 120));
draw_rectangle(_cx - 36, _cy + 34, _cx - 20, _cy + 46, false);
draw_rectangle(_cx + 20, _cy + 34, _cx + 36, _cy + 46, false);
draw_set_color(make_color_rgb(160, 128, 98));
draw_line(_cx - 32, _cy + 38, _cx - 22, _cy + 38);
draw_line(_cx + 22, _cy + 38, _cx + 32, _cy + 38);

// Neck
draw_set_color(make_color_rgb(185, 152, 120));
draw_rectangle(_cx - 7, _cy - 12, _cx + 5, _cy + 2, false);
// Head (drooped forward, slumped)
draw_set_color(make_color_rgb(190, 158, 126));
draw_circle(_cx - 5, _cy - 26, 17, false);
// Short dark hair
draw_set_color(make_color_rgb(38, 26, 16));
draw_ellipse(_cx - 20, _cy - 44, _cx + 8, _cy - 16, false);
// Ear (right, visible at slump angle)
draw_set_color(make_color_rgb(168, 138, 108));
draw_circle(_cx + 11, _cy - 24, 5, false);
draw_set_color(make_color_rgb(148, 118, 88));
draw_circle(_cx + 11, _cy - 24, 3, true);
// Brow ridge / closed eyes
draw_set_color(make_color_rgb(130, 104, 78));
draw_line(_cx - 16, _cy - 30, _cx - 5, _cy - 27);
draw_set_color(make_color_rgb(100, 78, 58));
draw_line(_cx - 15, _cy - 25, _cx - 5, _cy - 23);
// Jaw stubble
draw_set_color(make_color_rgb(145, 118, 94));
draw_set_alpha(0.38);
draw_ellipse(_cx - 16, _cy - 18, _cx + 5, _cy - 10, false);
draw_set_alpha(1);

// Rope strands
var _r0a = (rope_done[0]) ? 0.2 : 1.0;
draw_set_alpha(_r0a);
draw_set_color((active_strand == 0 && phase == 0) ? make_color_rgb(255, 220, 100) : make_color_rgb(180, 155, 90));
draw_line_width(_cx - 40, _cy + 10, _cx + 40, _cy + 14, 5);

var _r1a = (rope_done[1]) ? 0.2 : 1.0;
draw_set_alpha(_r1a);
draw_set_color((active_strand == 1 && phase == 0) ? make_color_rgb(255, 220, 100) : make_color_rgb(180, 155, 90));
draw_line_width(_cx - 40, _cy + 30, _cx + 40, _cy + 34, 5);

var _r2a = (rope_done[2]) ? 0.2 : 1.0;
draw_set_alpha(_r2a);
draw_set_color((active_strand == 2 && phase == 0) ? make_color_rgb(255, 220, 100) : make_color_rgb(180, 155, 90));
draw_line_width(_cx - 40, _cy + 52, _cx + 40, _cy + 56, 5);

draw_set_alpha(1);

// ============================================================
// BOMB ON TABLE (right side, x~1300, y~560)
// ============================================================
var _bx = 1300;
var _by = 560;

// Table
draw_set_color(make_color_rgb(70, 50, 30));
draw_rectangle(_bx - 120, _by + 60, _bx + 120, _by + 72, false);
draw_set_color(make_color_rgb(56, 40, 22));
draw_rectangle(_bx - 120, _by + 65, _bx + 120, _by + 67, false);
draw_rectangle(_bx - 115, _by + 70, _bx - 108, _by + 112, false);
draw_rectangle(_bx + 108, _by + 70, _bx + 115, _by + 112, false);

// Bomb body
draw_set_color(make_color_rgb(44, 50, 44));
draw_rectangle(_bx - 90, _by - 20, _bx + 90, _by + 60, false);
// Top highlight strip
draw_set_color(make_color_rgb(60, 66, 60));
draw_rectangle(_bx - 90, _by - 20, _bx + 90, _by - 13, false);
// Panel divider lines
draw_set_color(make_color_rgb(28, 32, 28));
draw_line(_bx - 54, _by - 18, _bx - 54, _by + 58);
draw_line(_bx + 54, _by - 18, _bx + 54, _by + 58);
// Corner rivets
draw_set_color(make_color_rgb(82, 82, 86));
draw_circle(_bx - 84, _by - 15, 3, false);
draw_circle(_bx + 84, _by - 15, 3, false);
draw_circle(_bx - 84, _by + 54, 3, false);
draw_circle(_bx + 84, _by + 54, 3, false);
draw_set_color(make_color_rgb(114, 114, 118));
draw_circle(_bx - 84, _by - 15, 1, false);
draw_circle(_bx + 84, _by - 15, 1, false);
// Warning sticker (left panel)
draw_set_color(make_color_rgb(218, 184, 28));
draw_rectangle(_bx - 88, _by + 16, _bx - 60, _by + 44, false);
draw_set_color(make_color_rgb(28, 20, 8));
draw_set_halign(fa_center);
draw_text_transformed(_bx - 74, _by + 20, "!", 1.5, 1.5, 0);
draw_set_halign(fa_left);
// Indicator LEDs (right panel)
var _led_on  = [make_color_rgb(220, 28, 28), make_color_rgb(28, 200, 58), make_color_rgb(220, 28, 28)];
var _led_off = [make_color_rgb(18, 8, 8), make_color_rgb(8, 18, 8), make_color_rgb(18, 8, 8)];
for (var _li = 0; _li < 5; _li++) {
    var _lon = (_li mod 2 == 0);
    draw_set_color(_lon ? _led_on[_li mod 3] : _led_off[_li mod 3]);
    draw_circle(_bx + 68, _by + 18 + _li * 9, 3, false);
}

// Digital timer (centre panel)
var _secs_left = max(floor(bomb_frames_left / 60), 0);
var _mins_disp = floor(_secs_left / 60);
var _secs_disp = _secs_left mod 60;
var _time_str  = string(_mins_disp) + ":" + ((_secs_disp < 10) ? "0" : "") + string(_secs_disp);

draw_set_color(make_color_rgb(7, 9, 7));
draw_rectangle(_bx - 52, _by - 8, _bx + 52, _by + 44, false);
draw_set_color(make_color_rgb(18, 38, 18));
draw_rectangle(_bx - 52, _by - 8, _bx + 52, _by + 44, true);
var _tc = (timer_red && (bomb_frames_left mod 60 < 30)) ? make_color_rgb(255, 40, 40) : make_color_rgb(60, 255, 60);
draw_set_color(_tc);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(_bx, _by + 17, _time_str, 2.2, 2.2, 0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Wires (5 colored, routed from bomb base)
var _wire_names  = ["RED", "BLUE", "GREEN", "YELLOW", "WHITE"];
var _wire_colors = [
    make_color_rgb(220, 40,  40),
    make_color_rgb(50,  100, 220),
    make_color_rgb(40,  180, 60),
    make_color_rgb(220, 200, 40),
    make_color_rgb(220, 220, 220),
];
for (var _wi = 0; _wi < 5; _wi++) {
    var _wx   = _bx - 80 + _wi * 40;
    var _wcut = (phase >= 1 && _wi == wire_correct);
    draw_set_color(_wire_colors[_wi]);
    if (_wcut) {
        draw_line_width(_wx, _by + 60, _wx, _by + 78, 3);
    } else {
        draw_line_width(_wx, _by + 60, _wx + (_wi - 2) * 3, _by + 92, 3);
    }
    draw_circle(_wx, _by + 60, 3, false);
}

// ============================================================
// TIMER COUNTDOWN BAR (top center, always visible during puzzle)
// ============================================================
if (phase == 0 || phase == 1) {
    var _tbw  = 600;
    var _tbh  = 20;
    var _tbx  = gw / 2 - _tbw / 2;
    var _tby  = 12;
    var _tpct = clamp(bomb_frames_left / timer_max, 0, 1);
    var _tclr = make_color_rgb(lerp(220, 60, 1 - _tpct), lerp(60, 220, _tpct), 40);

    draw_set_color(make_color_rgb(20, 20, 20));
    draw_rectangle(_tbx, _tby, _tbx + _tbw, _tby + _tbh, false);
    draw_set_color(_tclr);
    draw_rectangle(_tbx, _tby, _tbx + _tbw * _tpct, _tby + _tbh, false);
    draw_set_color(c_white);
    draw_rectangle(_tbx, _tby, _tbx + _tbw, _tby + _tbh, true);
    draw_set_halign(fa_center);
    draw_text_transformed(gw / 2, _tby + 1, _time_str + "  REMAINING", 0.85, 0.85, 0);
    draw_set_halign(fa_left);

    // Red screen flash when < 30 sec
    if (timer_red) {
        var _flash_a = abs(sin(_t * 4.0)) * 0.25;
        draw_set_color(make_color_rgb(180, 0, 0));
        draw_set_alpha(_flash_a);
        draw_rectangle(0, 0, gw, gh, false);
        draw_set_alpha(1);
    }
}

// ============================================================
// INTRO OVERLAY (capture narrative)
// ============================================================
if (intro_timer > 0) {
    var _ia = clamp(intro_timer / 60.0, 0, 1);
    draw_set_color(c_black);
    draw_set_alpha(0.85 * _ia);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(_ia);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(220, 60, 60));
    draw_text_transformed(gw/2, gh/2 - 80, "CAPTURED", 3.0, 3.0, 0);
    draw_set_color(c_white);
    draw_text_transformed(gw/2, gh/2,      "They had been waiting on the roof.", 1.2, 1.2, 0);
    draw_set_color(make_color_rgb(160, 148, 90));
    draw_text_transformed(gw/2, gh/2 + 50, "Dan wakes tied to a chair.", 1.0, 1.0, 0);
    draw_text_transformed(gw/2, gh/2 + 90, "The bomb beside him is counting down.", 1.0, 1.0, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    exit;
}

// ============================================================
// PHASE 0: ROPE PUZZLE UI
// ============================================================
if (phase == 0) {
    // Central panel
    draw_set_color(c_black);
    draw_set_alpha(0.75);
    draw_rectangle(gw/2 - 380, gh/2 - 160, gw/2 + 380, gh/2 + 170, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(180, 150, 70));
    draw_rectangle(gw/2 - 380, gh/2 - 160, gw/2 + 380, gh/2 + 170, true);

    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(255, 200, 60));
    draw_text_transformed(gw/2, gh/2 - 145, "BREAK FREE", 1.5, 1.5, 0);

    var _strand_labels = [
        "Strand 1  —  MASH SPACE (or A)",
        "Strand 2  —  TAP  LEFT / RIGHT  alternately",
        "Strand 3  —  HOLD J + K  (or LB + RB)",
    ];

    for (var _si = 0; _si < 3; _si++) {
        var _sy = gh/2 - 80 + _si * 80;
        var _is_active = (_si == active_strand);
        var _is_done   = rope_done[_si];

        // Highlight box
        if (_is_active && !_is_done) {
            draw_set_color(make_color_rgb(60, 50, 20));
            draw_set_alpha(0.6);
            draw_rectangle(gw/2 - 360, _sy - 4, gw/2 + 360, _sy + 50, false);
            draw_set_alpha(1);
        }

        // Label
        draw_set_color(_is_done ? make_color_rgb(80, 180, 80) : (_is_active ? make_color_rgb(255, 220, 80) : make_color_rgb(160, 148, 90)));
        draw_text_transformed(gw/2, _sy, _is_done ? (_strand_labels[_si] + "  [DONE]") : _strand_labels[_si], 0.88, 0.88, 0);

        // Progress bar
        var _pbw = 480;
        var _pbh = 14;
        var _pbx = gw/2 - _pbw/2;
        var _pby = _sy + 20;
        draw_set_color(make_color_rgb(30, 30, 30));
        draw_rectangle(_pbx, _pby, _pbx + _pbw, _pby + _pbh, false);
        var _fill_col = _is_done ? make_color_rgb(60, 200, 60) : (_is_active ? make_color_rgb(220, 180, 40) : make_color_rgb(100, 88, 40));
        draw_set_color(_fill_col);
        draw_rectangle(_pbx, _pby, _pbx + _pbw * rope_progress[_si], _pby + _pbh, false);
        draw_set_color(make_color_rgb(100, 88, 40));
        draw_rectangle(_pbx, _pby, _pbx + _pbw, _pby + _pbh, true);
    }

    draw_set_color(make_color_rgb(110, 100, 60));
    draw_text_transformed(gw/2, gh/2 + 145, "UP / DOWN to switch strand", 0.78, 0.78, 0);
    draw_set_halign(fa_left);
}

// ============================================================
// PHASE 1: BOMB PUZZLE UI
// ============================================================
if (phase == 1) {

    // ---- Step 0: Wire Selection ----
    if (bomb_step == 0) {
        var _wire_clue_texts = [
            "\"The blood never washed out. Couldn't get the red out.\"",
            "\"He said the blue river would keep them safe.\"",
            "\"The green jungle swallowed everything. Even the truth.\"",
            "\"One yellow flash of light in the dark. Then silence.\"",
            "\"They waved a white cloth. We didn't stop.\"",
        ];

        draw_set_color(c_black);
        draw_set_alpha(0.78);
        draw_rectangle(gw/2 - 440, gh/2 - 190, gw/2 + 440, gh/2 + 200, false);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(220, 60, 60));
        draw_rectangle(gw/2 - 440, gh/2 - 190, gw/2 + 440, gh/2 + 200, true);

        draw_set_halign(fa_center);
        draw_set_color(make_color_rgb(255, 80, 80));
        draw_text_transformed(gw/2, gh/2 - 175, "CUT THE RIGHT WIRE", 1.4, 1.4, 0);

        // Clue text (from bomb's instruction tag)
        draw_set_color(make_color_rgb(200, 185, 130));
        draw_text_transformed(gw/2, gh/2 - 125, "Field manual, page 47:", 0.82, 0.82, 0);
        draw_set_color(c_white);
        draw_text_transformed(gw/2, gh/2 - 96, _wire_clue_texts[wire_correct], 0.95, 0.95, 0);
        draw_set_color(make_color_rgb(140, 120, 70));
        draw_text_transformed(gw/2, gh/2 - 68, "Find the colour in the memory.", 0.78, 0.78, 0);

        // Wire options
        var _wire_names2  = ["RED", "BLUE", "GREEN", "YELLOW", "WHITE"];
        var _wire_colors2 = [
            make_color_rgb(220, 40,  40),
            make_color_rgb(80,  130, 240),
            make_color_rgb(60,  200, 80),
            make_color_rgb(230, 210, 50),
            make_color_rgb(230, 230, 230),
        ];
        for (var _wi2 = 0; _wi2 < 5; _wi2++) {
            var _wwx = gw/2 - 320 + _wi2 * 160;
            var _wwy = gh/2 + 10;
            var _is_sel = (_wi2 == wire_selected);

            // Selection highlight
            if (_is_sel) {
                draw_set_color(c_white);
                draw_set_alpha(0.25);
                draw_rectangle(_wwx - 50, _wwy - 10, _wwx + 50, _wwy + 80, false);
                draw_set_alpha(1);
                draw_set_color(c_white);
                draw_rectangle(_wwx - 50, _wwy - 10, _wwx + 50, _wwy + 80, true);
            }

            // Wire swatch circle
            draw_set_color(_wire_colors2[_wi2]);
            draw_circle(_wwx, _wwy + 25, 22, false);
            draw_set_color(c_black);
            draw_circle(_wwx, _wwy + 25, 22, true);

            // Wire label
            draw_set_color(_wire_colors2[_wi2]);
            draw_text_transformed(_wwx, _wwy + 54, _wire_names2[_wi2], 0.85, 0.85, 0);
        }

        draw_set_color(make_color_rgb(130, 120, 70));
        draw_text_transformed(gw/2, gh/2 + 160, "← → Select     SPACE Confirm (wrong wire = instant death)", 0.80, 0.80, 0);
        draw_set_halign(fa_left);
    }

    // ---- Step 1: Code Entry ----
    if (bomb_step == 1) {
        draw_set_color(c_black);
        draw_set_alpha(0.80);
        draw_rectangle(gw/2 - 380, gh/2 - 180, gw/2 + 380, gh/2 + 180, false);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(50, 200, 50));
        draw_rectangle(gw/2 - 380, gh/2 - 180, gw/2 + 380, gh/2 + 180, true);

        draw_set_halign(fa_center);
        draw_set_color(make_color_rgb(80, 220, 80));
        draw_text_transformed(gw/2, gh/2 - 165, "ENTER THE DISARM CODE", 1.3, 1.3, 0);

        // Code display — show if not hidden, otherwise show blanks
        draw_set_color(make_color_rgb(160, 148, 90));
        if (!code_hidden) {
            draw_text_transformed(gw/2, gh/2 - 110, "Memorise:", 0.90, 0.90, 0);
        }

        for (var _dd = 0; _dd < 4; _dd++) {
            var _dx = gw/2 - 150 + _dd * 100;
            var _dy = gh/2 - 70;
            draw_set_color(make_color_rgb(20, 20, 20));
            draw_rectangle(_dx - 35, _dy, _dx + 35, _dy + 54, false);
            if (!code_hidden) {
                draw_set_color(make_color_rgb(60, 220, 60));
                draw_text_transformed(_dx, _dy + 8, string(code_digits[_dd]), 2.0, 2.0, 0);
            } else {
                draw_set_color(make_color_rgb(40, 40, 40));
                draw_text_transformed(_dx, _dy + 8, "?", 2.0, 2.0, 0);
            }
        }

        // Divider
        draw_set_color(make_color_rgb(60, 100, 60));
        draw_line(gw/2 - 340, gh/2 - 4, gw/2 + 340, gh/2 - 4);

        // Player input boxes
        draw_set_color(make_color_rgb(140, 128, 70));
        draw_text_transformed(gw/2, gh/2 + 10, "Your input:", 0.90, 0.90, 0);

        for (var _di = 0; _di < 4; _di++) {
            var _ix = gw/2 - 150 + _di * 100;
            var _iy = gh/2 + 38;
            var _is_cur = (_di == code_cursor);
            draw_set_color(_is_cur ? make_color_rgb(60, 220, 60) : make_color_rgb(40, 60, 40));
            draw_rectangle(_ix - 35, _iy, _ix + 35, _iy + 54, false);
            draw_set_color(_is_cur ? c_white : make_color_rgb(100, 100, 100));
            draw_rectangle(_ix - 35, _iy, _ix + 35, _iy + 54, true);
            if (code_input[_di] >= 0) {
                draw_set_color(c_white);
                draw_text_transformed(_ix, _iy + 8, string(code_input[_di]), 2.0, 2.0, 0);
            } else if (_is_cur) {
                // Blinking cursor
                if ((bomb_frames_left mod 60) < 30) {
                    draw_set_color(make_color_rgb(60, 220, 60));
                    draw_text_transformed(_ix, _iy + 8, "_", 2.0, 2.0, 0);
                }
            }
        }

        // Wrong code flash
        if (code_wrong_flash > 0) {
            draw_set_color(make_color_rgb(220, 40, 40));
            draw_set_alpha(code_wrong_flash / 90.0);
            draw_text_transformed(gw/2, gh/2 + 108, "WRONG CODE  -15 SECONDS", 1.1, 1.1, 0);
            draw_set_alpha(1);
        }

        draw_set_color(make_color_rgb(110, 100, 60));
        draw_text_transformed(gw/2, gh/2 + 148, "Type digits (0–9)  |  Backspace to erase  |  Space to confirm", 0.78, 0.78, 0);
        draw_set_halign(fa_left);
    }

    // ---- Step 2: Pull the detonator ----
    if (bomb_step == 2) {
        draw_set_color(c_black);
        draw_set_alpha(0.80);
        draw_rectangle(gw/2 - 360, gh/2 - 140, gw/2 + 360, gh/2 + 130, false);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(220, 180, 40));
        draw_rectangle(gw/2 - 360, gh/2 - 140, gw/2 + 360, gh/2 + 130, true);

        draw_set_halign(fa_center);
        draw_set_color(make_color_rgb(255, 220, 60));
        draw_text_transformed(gw/2, gh/2 - 120, "PULL THE DETONATOR", 1.4, 1.4, 0);
        draw_set_color(c_white);
        draw_text_transformed(gw/2, gh/2 - 72, "Hold LEFT + RIGHT simultaneously", 1.0, 1.0, 0);
        if (gamepad_is_connected(0)) {
            draw_set_color(make_color_rgb(160, 148, 90));
            draw_text_transformed(gw/2, gh/2 - 44, "(or hold LB + RB on gamepad)", 0.88, 0.88, 0);
        }

        // Hold progress bar
        var _dpct = clamp(detonator_hold / detonator_need, 0, 1);
        var _dbw  = 500;
        var _dbh  = 28;
        var _dbx  = gw/2 - _dbw/2;
        var _dby  = gh/2 + 10;
        draw_set_color(make_color_rgb(30, 30, 30));
        draw_rectangle(_dbx, _dby, _dbx + _dbw, _dby + _dbh, false);
        draw_set_color(make_color_rgb(220, 180, 40));
        draw_rectangle(_dbx, _dby, _dbx + _dbw * _dpct, _dby + _dbh, false);
        draw_set_color(c_white);
        draw_rectangle(_dbx, _dby, _dbx + _dbw, _dby + _dbh, true);
        draw_text_transformed(gw/2, _dby + 4, string(floor(_dpct * 100)) + "%", 0.88, 0.88, 0);

        draw_set_color(make_color_rgb(110, 100, 60));
        draw_text_transformed(gw/2, gh/2 + 100, "Hold steady — releasing will reset progress", 0.80, 0.80, 0);
        draw_set_halign(fa_left);
    }
}

// ============================================================
// PHASE 2: WIN / NARRATIVE REVEAL
// ============================================================
if (phase == 2) {
    var _wa = clamp(end_timer / 60.0, 0, 1);

    // Slide 0 — DEFUSED (first 3 seconds auto, before input unlocks)
    if (narrative_slide == 0) {
        draw_set_color(make_color_rgb(8, 30, 8));
        draw_set_alpha(0.90 * _wa);
        draw_rectangle(0, 0, gw, gh, false);
        draw_set_alpha(_wa);

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(80, 220, 80));
        draw_text_transformed(gw/2, gh/2 - 60, "DEFUSED", 4.0, 4.0, 0);
        draw_set_color(c_white);
        draw_text_transformed(gw/2, gh/2 + 40, "Hands shaking. Wire still warm.", 1.1, 1.1, 0);
        if (end_timer > 180) {
            draw_set_color(make_color_rgb(110, 100, 60));
            draw_text_transformed(gw/2, gh/2 + 100, "SPACE to continue", 0.80, 0.80, 0);
        }
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_alpha(1);
        exit;
    }

    // Helper: fade alpha per slide (0→1 over 45 frames)
    var _sfa = clamp(slide_fade_in / 45.0, 0, 1);

    // Background: deep black for all narrative slides
    draw_set_color(c_black);
    draw_set_alpha(0.92);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    // Thin amber line across the upper third (cinematic letterbox feel)
    draw_set_color(make_color_rgb(140, 110, 40));
    draw_set_alpha(0.4 * _sfa);
    draw_rectangle(0, 160, gw, 163, false);
    draw_rectangle(0, gh - 163, gw, gh - 160, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(_sfa);

    // Each slide: main text + sub-text
    var _main = "";
    var _sub  = "";
    var _sub2 = "";
    var _main_col = c_white;
    var _sub_col  = make_color_rgb(160, 148, 90);

    if (narrative_slide == 1) {
        _main = "He sat in the silence.";
        _sub  = "The wire. The knots. The placement of the device.";
        _sub2 = "Something gnawed at him through the adrenaline.";
    }
    if (narrative_slide == 2) {
        _main = "The rope on the chair.";
        _sub  = "J-knot, half-hitched at the wrist.";
        _sub2 = "He'd only ever seen one man tie it that way.";
    }
    if (narrative_slide == 3) {
        _main = "\"The ghost tie.\"";
        _sub  = "They called it that because it held even dead men in place.";
        _sub2 = "Sergeant Reyes taught him that knot. In a ditch outside Khe Sanh.";
    }
    if (narrative_slide == 4) {
        _main = "The bomb.";
        _sub  = "C4 laminate, layered in threes. Timer bridged with stripped field wire.";
        _sub2 = "Reyes' signature. Every demo op, same pattern. Every time.";
    }
    if (narrative_slide == 5) {
        _main = "Reyes.";
        _main_col = make_color_rgb(220, 80, 80);
        _sub  = "His brother in everything but blood.";
        _sub2 = "Foxhole to foxhole. Khe Sanh. Quang Tri. The village no one was supposed to remember.";
    }
    if (narrative_slide == 6) {
        _main = "Reyes had pulled him from a burning APC.";
        _sub  = "Dragged him out of a flooded tunnel at Cu Chi.";
        _sub2 = "Said it was nothing. Said that's what brothers do.";
    }
    if (narrative_slide == 7) {
        _main = "And now Reyes had left him on this roof to burn.";
        _main_col = make_color_rgb(220, 80, 80);
        _sub  = "Not a stranger. Not an enemy.";
        _sub2 = "The one man Dan trusted with his life.";
        _sub_col = make_color_rgb(200, 140, 140);
    }
    if (narrative_slide == 8) {
        _main = "Why?";
        _main_col = make_color_rgb(255, 220, 60);
        var _ret_a = clamp((slide_fade_in - 120) / 60.0, 0, 1);
        draw_set_color(make_color_rgb(80, 70, 40));
        draw_set_alpha(_ret_a * _sfa);
        draw_text_transformed(gw/2, gh/2 + 110, "Returning to main menu...", 0.80, 0.80, 0);
        draw_set_alpha(_sfa);
    }

    draw_set_color(_main_col);
    draw_text_transformed(gw/2, gh/2 - 50, _main, 1.6, 1.6, 0);
    draw_set_color(_sub_col);
    draw_text_transformed(gw/2, gh/2 + 20, _sub, 1.0, 1.0, 0);
    draw_text_transformed(gw/2, gh/2 + 58, _sub2, 1.0, 1.0, 0);

    // Prompt (not on final slide)
    if (narrative_slide < 8 && slide_fade_in > 60) {
        var _pulse = abs(sin(current_time * 0.004)) * 0.6 + 0.3;
        draw_set_color(make_color_rgb(100, 90, 50));
        draw_set_alpha(_pulse * _sfa);
        draw_text_transformed(gw/2, gh - 50, "SPACE to continue", 0.78, 0.78, 0);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
}

// ============================================================
// PHASE 3: DEAD
// ============================================================
if (phase == 3) {
    var _da = clamp(end_timer / 60.0, 0, 1);
    draw_set_color(make_color_rgb(60, 0, 0));
    draw_set_alpha(0.88 * _da);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(_da);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(220, 40, 40));

    if (bomb_frames_left <= 0) {
        draw_text_transformed(gw/2, gh/2 - 80, "TIME'S UP", 3.0, 3.0, 0);
        draw_set_color(make_color_rgb(180, 120, 120));
        draw_text_transformed(gw/2, gh/2,      "The rooftop lit up against the night sky.", 1.2, 1.2, 0);
    } else {
        draw_text_transformed(gw/2, gh/2 - 80, "WRONG WIRE", 3.0, 3.0, 0);
        draw_set_color(make_color_rgb(180, 120, 120));
        draw_text_transformed(gw/2, gh/2,      "He closed his eyes. Then nothing.", 1.2, 1.2, 0);
    }
    draw_set_color(make_color_rgb(140, 80, 80));
    draw_text_transformed(gw/2, gh/2 + 60, "Every wrong choice has a price.", 1.0, 1.0, 0);
    if (end_timer > 90) {
        draw_set_color(make_color_rgb(120, 100, 80));
        draw_text_transformed(gw/2, gh/2 + 110, "Press R (or Start) to try again", 0.85, 0.85, 0);
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
}

// Score (top-right, visible during active phases)
if (phase == 1 || phase == 2) {
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_set_alpha(0.55);
    draw_rectangle(gw - 280, 8, gw - 8, 50, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(220, 220, 80));
    draw_set_halign(fa_right);
    draw_text_transformed(gw - 16, 12, "SCORE  " + string(global.score), 1.0, 1.0, 0);
    draw_set_halign(fa_left);
}
// Kill flash
if (global.kill_flash_timer > 0) {
    global.kill_flash_timer--;
    draw_set_color(c_white);
    draw_set_alpha((global.kill_flash_timer + 1) / 5.0 * 0.28);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}
// Memory fragment text
if (global.memory_timer > 0) {
    global.memory_timer--;
    var _mf   = min(global.memory_timer / 40.0, 1.0) * min((210 - global.memory_timer) / 40.0, 1.0);
    var _ckpt = (string_char_at(global.memory_text, 1) == "-");
    draw_set_alpha(clamp(_mf, 0, 1) * 0.92);
    draw_set_color(_ckpt ? make_color_rgb(80, 230, 100) : make_color_rgb(220, 200, 130));
    draw_set_halign(fa_center);
    draw_text_transformed(gw / 2, _ckpt ? gh * 0.50 : gh * 0.72,
        global.memory_text, _ckpt ? 1.4 : 1.05, _ckpt ? 1.4 : 1.05, 0);
    draw_set_halign(fa_left);
    draw_set_alpha(1);
}
// Room fade-in on entry
if (room_fade > 0) {
    room_fade--;
    draw_set_color(c_black);
    draw_set_alpha(room_fade / 45.0);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}

// ============================================================
// PAUSE OVERLAY
// ============================================================
if (global.game_state == 4) {
    draw_set_color(c_black);
    draw_set_alpha(0.80);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    var _pw = 480; var _ph = 300;
    var _px = gw / 2 - _pw / 2;
    var _py = gh / 2 - _ph / 2;
    draw_set_color(make_color_rgb(20, 20, 28));
    draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
    draw_set_color(make_color_rgb(180, 160, 80));
    draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(220, 200, 80));
    draw_text_transformed(gw / 2, _py + 44, "PAUSED", 2.2, 2.2, 0);

    if (!pause_settings) {
        var _items = ["RESUME", "SETTINGS", "QUIT TO MENU"];
        for (var _pi = 0; _pi < 3; _pi++) {
            var _iy = _py + 120 + _pi * 52;
            var _sel = (pause_sel == _pi);
            draw_set_color(_sel ? make_color_rgb(255, 220, 80) : make_color_rgb(160, 148, 90));
            draw_text_transformed(gw / 2, _iy, _items[_pi], _sel ? 1.05 : 0.95, _sel ? 1.05 : 0.95, 0);
            if (_sel) {
                draw_set_color(make_color_rgb(220, 200, 80));
                draw_text_transformed(gw / 2 - 140, _iy, ">", 1.05, 1.05, 0);
                draw_text_transformed(gw / 2 + 140, _iy, "<", 1.05, 1.05, 0);
            }
        }
        draw_set_color(make_color_rgb(90, 80, 48));
        draw_text_transformed(gw / 2, _py + _ph - 28, "W/S move  |  SPACE select  |  ESC resume", 0.70, 0.70, 0);
    } else {
        draw_set_color(make_color_rgb(180, 165, 90));
        draw_text_transformed(gw / 2, _py + 104, "AUDIO SETTINGS", 1.0, 1.0, 0);

        var _snames = ["MUSIC", "SFX"];
        var _svals  = [global.vol_music, global.vol_sfx];
        for (var _si4 = 0; _si4 < 2; _si4++) {
            var _sy4 = _py + 162 + _si4 * 62;
            var _ssl = (pause_settings_sel == _si4);
            draw_set_color(_ssl ? make_color_rgb(255, 220, 80) : make_color_rgb(160, 148, 90));
            draw_text_transformed(gw / 2, _sy4 - 16, _snames[_si4], 0.90, 0.90, 0);
            var _bw4 = 280; var _bh4 = 16;
            var _bx4 = gw / 2 - _bw4 / 2;
            draw_set_color(make_color_rgb(30, 30, 30));
            draw_rectangle(_bx4, _sy4 + 2, _bx4 + _bw4, _sy4 + 2 + _bh4, false);
            draw_set_color(_ssl ? make_color_rgb(220, 180, 40) : make_color_rgb(100, 90, 48));
            draw_rectangle(_bx4, _sy4 + 2, _bx4 + _bw4 * _svals[_si4], _sy4 + 2 + _bh4, false);
            draw_set_color(make_color_rgb(100, 90, 50));
            draw_rectangle(_bx4, _sy4 + 2, _bx4 + _bw4, _sy4 + 2 + _bh4, true);
            draw_set_color(_ssl ? make_color_rgb(255, 220, 80) : make_color_rgb(140, 130, 70));
            draw_text_transformed(gw / 2 + _bw4 / 2 + 20, _sy4 + 2, string(round(_svals[_si4] * 100)) + "%", 0.80, 0.80, 0);
        }
        draw_set_color(make_color_rgb(90, 80, 48));
        draw_text_transformed(gw / 2, _py + _ph - 28, "W/S select  |  A/D adjust  |  ESC back", 0.70, 0.70, 0);
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
}
draw_set_color(c_white);
