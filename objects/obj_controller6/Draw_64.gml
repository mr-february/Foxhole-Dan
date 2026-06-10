var gw = display_get_gui_width();
var gh = display_get_gui_height();

// =========================================================
// ROOM — dim interior
// =========================================================
draw_set_color(make_color_rgb(46, 40, 30));
draw_rectangle(0, 0, 1920, 768, false);

// Floor
draw_set_color(make_color_rgb(58, 48, 34));
draw_rectangle(0, 560, 1920, 768, false);
// Floor baseboard
draw_set_color(make_color_rgb(48, 40, 28));
draw_rectangle(0, 556, 1920, 566, false);

// Wall
draw_set_color(make_color_rgb(68, 60, 48));
draw_rectangle(0, 0, 1920, 560, false);

// =========================================================
// WINDOW (right side of room)
// =========================================================
var wx = 1280;
var wy = 160;
var ww = 240;
var wh = 200;

// Frame
draw_set_color(make_color_rgb(88, 78, 60));
draw_rectangle(wx - 8, wy - 8, wx + ww + 8, wy + wh + 8, false);

if (window_flicker) {
    // Combat flash — terrain silhouette for 3 frames
    draw_set_color(make_color_rgb(90, 64, 28));
    draw_rectangle(wx, wy, wx + ww, wy + wh, false);
    draw_set_color(make_color_rgb(18, 14, 8));
    draw_rectangle(wx,       wy + 130, wx + 60,  wy + wh, false);
    draw_rectangle(wx + 70,  wy + 110, wx + 150, wy + wh, false);
    draw_rectangle(wx + 160, wy + 125, wx + ww,  wy + wh, false);
} else {
    // Quiet daytime street
    draw_set_alpha(0.5);
    draw_set_color(make_color_rgb(160, 192, 218));
    draw_rectangle(wx, wy, wx + ww, wy + wh, false);
    draw_set_alpha(1);
    // Window dividers
    draw_set_color(make_color_rgb(78, 68, 52));
    draw_line_width(wx + ww/2, wy, wx + ww/2, wy + wh, 3);
    draw_line_width(wx, wy + wh/2, wx + ww, wy + wh/2, 3);
    // Street silhouette (house outline, tree)
    draw_set_alpha(0.35);
    draw_set_color(make_color_rgb(40, 56, 72));
    draw_rectangle(wx + 10,  wy + 110, wx + 90,  wy + wh, false);
    draw_rectangle(wx + 30,  wy + 80,  wx + 70,  wy + 110, false);
    draw_set_color(make_color_rgb(30, 52, 28));
    draw_circle(wx + 160, wy + 120, 28, false);
    draw_rectangle(wx + 155, wy + 140, wx + 165, wy + wh, false);
    draw_set_alpha(1);
}

// =========================================================
// TABLE
// =========================================================
var tx = 320;
var ty = 468;
// Table top (oak)
draw_set_color(make_color_rgb(96, 70, 40));
draw_rectangle(tx, ty, tx + 500, ty + 18, false);
// Table top highlight
draw_set_color(make_color_rgb(108, 80, 48));
draw_rectangle(tx + 4, ty + 2, tx + 496, ty + 7, false);
// Legs
draw_set_color(make_color_rgb(78, 56, 32));
draw_rectangle(tx + 18,  ty + 18, tx + 32,  ty + 160, false);
draw_rectangle(tx + 450, ty + 18, tx + 464, ty + 160, false);
// Shadow under table
draw_set_alpha(0.28);
draw_set_color(c_black);
draw_ellipse(tx + 60, ty + 160, tx + 440, ty + 172, false);
draw_set_alpha(1);

// =========================================================
// MUG
// =========================================================
var mx = 580;
var my = ty - 44;
// Mug body
draw_set_color(make_color_rgb(192, 174, 152));
draw_rectangle(mx - 13, my, mx + 13, my + 38, false);
// Coffee surface
draw_set_color(make_color_rgb(42, 24, 10));
draw_rectangle(mx - 11, my + 2, mx + 11, my + 10, false);
// Handle (C shape)
draw_set_color(make_color_rgb(174, 158, 136));
draw_circle(mx + 18, my + 20, 9, true);
draw_set_color(make_color_rgb(192, 174, 152));
draw_circle(mx + 18, my + 20, 5, true);
// Steam (only in phase 0-1 before weight sets in)
if (phase <= 1) {
    var _st = (current_time mod 90) / 90.0;
    draw_set_alpha(0.22);
    draw_set_color(make_color_rgb(230, 224, 215));
    draw_circle(mx - 2 + irandom(3), my - 10 - _st * 18, 4, false);
    draw_circle(mx + 4 + irandom(3), my - 6  - _st * 14, 3, false);
    draw_set_alpha(1);
}

// =========================================================
// DAN — civilian, slumped at table
// =========================================================
var dx = 520;
var dy = ty - 90;

// Chair back posts
draw_set_color(make_color_rgb(70, 54, 36));
draw_rectangle(dx - 20, dy - 20, dx - 16, dy + 55, false);
draw_rectangle(dx + 16, dy - 20, dx + 20, dy + 55, false);
draw_rectangle(dx - 20, dy - 21, dx + 20, dy - 17, false);
draw_rectangle(dx - 20, dy - 5,  dx + 20, dy - 1,  false);

// Body — plain civilian shirt (washed-out blue-grey, no gear)
draw_set_color(make_color_rgb(94, 106, 118));
draw_rectangle(dx - 15, dy, dx + 15, dy + 48, false);
// Slumped shoulders
draw_set_color(make_color_rgb(102, 114, 126));
draw_rectangle(dx - 18, dy - 12, dx + 18, dy + 4, false);
// Shoulder highlight
draw_set_color(make_color_rgb(112, 124, 136));
draw_line(dx - 17, dy - 11, dx + 17, dy - 11);

// Arms on table
draw_set_color(make_color_rgb(94, 106, 118));
draw_rectangle(dx - 14, dy + 8, dx + 60, dy + 22, false);

// Right hand wrapped around mug
draw_set_color(make_color_rgb(188, 148, 100));
draw_circle(mx - 13, my + 22, 7, false);
// Fingers
draw_set_color(make_color_rgb(178, 138, 92));
draw_line(mx - 18, my + 17, mx - 21, my + 13);
draw_line(mx - 18, my + 22, mx - 22, my + 20);
draw_line(mx - 17, my + 27, mx - 20, my + 30);

// Head (looking down at mug)
draw_set_color(make_color_rgb(188, 148, 100));
draw_rectangle(dx - 9, dy - 26, dx + 9, dy - 2, false);
// Jawline shadow
draw_set_color(make_color_rgb(158, 118, 76));
draw_rectangle(dx - 8, dy - 6, dx + 8, dy - 2, false);
// Eyes — downcast
draw_set_color(make_color_rgb(38, 34, 28));
draw_rectangle(dx - 5, dy - 16, dx - 3, dy - 13, false);
draw_rectangle(dx + 2, dy - 16, dx + 4, dy - 13, false);
// Stubble
draw_set_color(make_color_rgb(148, 112, 76));
draw_rectangle(dx - 7, dy - 8, dx + 7, dy - 4, false);
// Hair — short civilian cut, no helmet
draw_set_color(make_color_rgb(54, 42, 28));
draw_rectangle(dx - 9, dy - 28, dx + 9, dy - 22, false);
draw_rectangle(dx - 10, dy - 26, dx - 8, dy - 14, false);

// =========================================================
// TEXT OVERLAY
// =========================================================
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(-1);

// "He made it home." — appears in phase 1-5
if (phase >= 1 && phase <= 5) {
    var _a1 = 0;
    if (phase == 1) _a1 = min(phase_timer / 60.0, 1.0);
    else if (phase >= 2) _a1 = 1.0;
    if (phase == 5 && phase_timer > 60) _a1 = max(1.0 - (phase_timer - 60) / 80.0, 0);
    draw_set_alpha(_a1 * 0.88);
    draw_set_color(make_color_rgb(228, 218, 198));
    draw_text_transformed(gw / 2, gh / 2 - 28, "He made it home.", 1.1, 1.1, 0);
    draw_set_alpha(1);
}

// "He always makes it home." — appears in phase 3-5
if (phase >= 3 && phase <= 5) {
    var _a2 = 0;
    if (phase == 3) _a2 = min(phase_timer / 60.0, 1.0);
    else if (phase >= 4) _a2 = 1.0;
    if (phase == 5 && phase_timer > 60) _a2 = max(1.0 - (phase_timer - 60) / 80.0, 0);
    draw_set_alpha(_a2 * 0.72);
    draw_set_color(make_color_rgb(190, 182, 168));
    draw_text_transformed(gw / 2, gh / 2 + 24, "He always makes it home.", 0.95, 0.95, 0);
    draw_set_alpha(1);
}

// =========================================================
// FADE OVERLAY
// =========================================================
if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
