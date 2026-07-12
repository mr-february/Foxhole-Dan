var gw = 1920;
var gh = 768;
var _t = current_time * 0.001;

// ============================================================
// BACKGROUND: Site 9 interrogation room
// ============================================================

// Concrete walls — near-black, slightly warmer near the floor
var wall_top = make_color_rgb(8, 8, 11);
var wall_bot = make_color_rgb(22, 21, 24);
draw_rectangle_color(0, 0, gw, 600, wall_top, wall_top, wall_bot, wall_bot, false);

// Floor
draw_set_color(make_color_rgb(30, 29, 32));
draw_rectangle(0, 600, gw, gh, false);
draw_set_color(make_color_rgb(40, 39, 43));
draw_rectangle(0, 600, gw, 606, false);   // wall/floor seam highlight
// Floor slab joints
draw_set_color(make_color_rgb(22, 21, 24));
for (var _fx = 0; _fx < gw; _fx += 160) {
    draw_line(_fx, 606, _fx - 40, gh);
}
// Drain in the floor (they hosed this room down before)
draw_set_color(make_color_rgb(14, 14, 16));
draw_ellipse(880, 700, 1040, 730, false);
draw_set_color(make_color_rgb(48, 47, 52));
draw_ellipse(880, 700, 1040, 730, true);
for (var _dg = 0; _dg < 5; _dg++) {
    draw_line(905 + _dg * 28, 706, 905 + _dg * 28, 724);
}

// Wall details — pipe run and a painted stencil
draw_set_color(make_color_rgb(34, 33, 38));
draw_rectangle(0, 90, gw, 100, false);          // pipe
draw_set_color(make_color_rgb(26, 25, 30));
draw_rectangle(300, 86, 308, 104, false);       // pipe bracket
draw_rectangle(1500, 86, 1508, 104, false);
draw_set_color(make_color_rgb(52, 46, 40));
draw_set_alpha(0.5);
draw_set_halign(fa_center);
draw_text_transformed(240, 160, "SITE 9", 1.1, 1.1, 0);
draw_text_transformed(240, 190, "AUTHORIZED PERSONNEL", 0.7, 0.7, 0);
draw_set_halign(fa_left);
draw_set_alpha(1);

// Hanging lamp — slight swing
var _sway   = sin(_t * 0.8) * 9;
var _lamp_x = 860 + _sway;
var _lamp_y = 200;
// Cord
draw_set_color(make_color_rgb(50, 48, 46));
draw_line_width(860, 0, _lamp_x, _lamp_y, 3);
// Shade (trapezoid)
draw_set_color(make_color_rgb(56, 52, 44));
draw_triangle(_lamp_x - 46, _lamp_y + 34, _lamp_x + 46, _lamp_y + 34, _lamp_x, _lamp_y - 6, false);
draw_set_color(make_color_rgb(40, 37, 31));
draw_line_width(_lamp_x - 46, _lamp_y + 34, _lamp_x + 46, _lamp_y + 34, 3);
// Bulb + glow
draw_set_color(make_color_rgb(255, 236, 170));
draw_circle(_lamp_x, _lamp_y + 30, 8, false);
draw_set_alpha(0.35);
draw_circle(_lamp_x, _lamp_y + 30, 18, false);
draw_set_alpha(0.12);
draw_circle(_lamp_x, _lamp_y + 30, 40, false);
draw_set_alpha(1);

// Light cone (layered triangles) + pool on the floor
draw_set_color(make_color_rgb(255, 232, 160));
draw_set_alpha(0.10);
draw_triangle(_lamp_x, _lamp_y + 34, _lamp_x - 300, 700, _lamp_x + 300, 700, false);
draw_set_alpha(0.07);
draw_triangle(_lamp_x, _lamp_y + 34, _lamp_x - 210, 700, _lamp_x + 210, 700, false);
draw_set_alpha(0.10);
draw_ellipse(_lamp_x - 300, 640, _lamp_x + 300, 730, false);
draw_set_alpha(1);

// ============================================================
// DAN — strapped into a steel chair under the lamp (x~860, y~470)
// ============================================================
var _cx = 860;
var _cy = 470;

// Steel chair legs
draw_set_color(make_color_rgb(58, 60, 66));
draw_rectangle(_cx - 30, _cy + 58, _cx - 24, _cy + 128, false);
draw_rectangle(_cx + 24, _cy + 58, _cx + 30, _cy + 128, false);
draw_set_color(make_color_rgb(44, 46, 52));
draw_rectangle(_cx - 28, _cy + 96, _cx + 28, _cy + 101, false);   // crossbar
// Seat
draw_set_color(make_color_rgb(74, 76, 84));
draw_rectangle(_cx - 34, _cy + 52, _cx + 34, _cy + 64, false);
// Back frame
draw_set_color(make_color_rgb(74, 76, 84));
draw_rectangle(_cx - 34, _cy - 46, _cx - 27, _cy + 54, false);
draw_rectangle(_cx + 27, _cy - 46, _cx + 34, _cy + 54, false);
draw_rectangle(_cx - 34, _cy - 50, _cx + 34, _cy - 44, false);

// Boots
draw_set_color(make_color_rgb(32, 26, 20));
draw_rectangle(_cx - 24, _cy + 112, _cx - 4, _cy + 128, false);
draw_rectangle(_cx + 4,  _cy + 112, _cx + 24, _cy + 128, false);
// Jeans (1983 — a burned-out vet, not a uniform)
draw_set_color(make_color_rgb(46, 54, 70));
draw_rectangle(_cx - 21, _cy + 52, _cx - 4, _cy + 114, false);
draw_rectangle(_cx + 4,  _cy + 52, _cx + 21, _cy + 114, false);
// Old field jacket / torso
draw_set_color(make_color_rgb(72, 82, 60));
draw_rectangle(_cx - 22, _cy - 12, _cx + 22, _cy + 54, false);
draw_set_color(make_color_rgb(56, 66, 46));
draw_rectangle(_cx - 11, _cy - 12, _cx + 11, _cy + 4, false);    // collar shadow
// Rolled left sleeve + the drip line into his arm
draw_set_color(make_color_rgb(190, 156, 122));
draw_rectangle(_cx + 22, _cy + 8, _cx + 42, _cy + 20, false);    // bare forearm on armrest
draw_set_color(make_color_rgb(210, 214, 224));
draw_line_width(_cx + 36, _cy + 12, 1210, 300, 1);               // IV line up to the stand
// IV stand + bag
draw_set_color(make_color_rgb(70, 72, 80));
draw_line_width(1210, 300, 1210, 660, 3);
draw_line_width(1180, 660, 1240, 660, 3);
draw_set_color(make_color_rgb(200, 210, 190));
draw_set_alpha(0.85);
draw_rectangle(1196, 260, 1224, 302, false);
draw_set_alpha(1);
draw_set_color(make_color_rgb(150, 160, 140));
draw_rectangle(1196, 260, 1224, 302, true);

// Right arm strapped down
draw_set_color(make_color_rgb(72, 82, 60));
draw_rectangle(_cx - 42, _cy + 6, _cx - 22, _cy + 34, false);
draw_set_color(make_color_rgb(190, 156, 122));
draw_rectangle(_cx - 42, _cy + 30, _cx - 22, _cy + 42, false);   // hand

// Restraint straps — surgical, not rope
draw_set_color(make_color_rgb(150, 146, 138));
draw_line_width(_cx - 44, _cy + 6,  _cx + 44, _cy + 10, 6);      // chest
draw_line_width(_cx - 44, _cy + 36, _cx - 20, _cy + 40, 6);      // right wrist
draw_line_width(_cx + 20, _cy + 14, _cx + 44, _cy + 16, 6);      // left wrist
draw_set_color(make_color_rgb(90, 88, 82));
draw_rectangle(_cx - 4, _cy + 4, _cx + 4, _cy + 12, false);      // buckle

// Neck + head — up, eyes into the lamp. He is not slumped. Not yet.
draw_set_color(make_color_rgb(190, 156, 122));
draw_rectangle(_cx - 7, _cy - 16, _cx + 6, _cy - 4, false);
draw_set_color(make_color_rgb(196, 162, 128));
draw_circle(_cx, _cy - 32, 17, false);
// Hair — short, greying at the temple
draw_set_color(make_color_rgb(44, 34, 24));
draw_ellipse(_cx - 16, _cy - 50, _cx + 16, _cy - 28, false);
draw_set_color(make_color_rgb(120, 116, 110));
draw_set_alpha(0.5);
draw_ellipse(_cx + 8, _cy - 44, _cx + 16, _cy - 34, false);
draw_set_alpha(1);
// Eyes — narrowed against the light
draw_set_color(make_color_rgb(120, 92, 66));
draw_line(_cx - 11, _cy - 33, _cx - 4, _cy - 33);
draw_line(_cx + 4,  _cy - 33, _cx + 11, _cy - 33);
// Bruise on the cheekbone (they softened him up first)
draw_set_color(make_color_rgb(110, 70, 90));
draw_set_alpha(0.45);
draw_ellipse(_cx + 5, _cy - 26, _cx + 13, _cy - 20, false);
draw_set_alpha(1);
// Jaw stubble
draw_set_color(make_color_rgb(150, 122, 96));
draw_set_alpha(0.35);
draw_ellipse(_cx - 12, _cy - 24, _cx + 12, _cy - 14, false);
draw_set_alpha(1);
// Sweat line
draw_set_color(make_color_rgb(230, 236, 244));
draw_set_alpha(0.30 + 0.15 * sin(_t * 3.0));
draw_line(_cx - 6, _cy - 44, _cx - 7, _cy - 36);
draw_set_alpha(1);

// Polygraph wire from Dan's chest to the machine on the table
draw_set_color(make_color_rgb(90, 90, 100));
draw_line_width(_cx + 20, _cy + 8, 1330, 552, 1);

// ============================================================
// TABLE (right) — tape recorder, polygraph, the MK-ECHO folder
// ============================================================
var _bx = 1400;
var _by = 560;

draw_set_color(make_color_rgb(58, 44, 30));
draw_rectangle(_bx - 150, _by, _bx + 150, _by + 12, false);
draw_set_color(make_color_rgb(44, 33, 22));
draw_rectangle(_bx - 144, _by + 12, _bx - 136, _by + 130, false);
draw_rectangle(_bx + 136, _by + 12, _bx + 144, _by + 130, false);

// Reel-to-reel tape recorder — reels spin while the session runs
draw_set_color(make_color_rgb(46, 48, 46));
draw_rectangle(_bx - 140, _by - 46, _bx - 40, _by, false);
draw_set_color(make_color_rgb(62, 64, 62));
draw_rectangle(_bx - 140, _by - 46, _bx - 40, _by - 40, false);
var _spin = _t * 2.2;
for (var _rl = 0; _rl < 2; _rl++) {
    var _rcx = _bx - 116 + _rl * 52;
    var _rcy = _by - 22;
    draw_set_color(make_color_rgb(24, 24, 24));
    draw_circle(_rcx, _rcy, 15, false);
    draw_set_color(make_color_rgb(120, 118, 112));
    draw_circle(_rcx, _rcy, 15, true);
    draw_line(_rcx, _rcy, _rcx + cos(_spin) * 12, _rcy - sin(_spin) * 12);
    draw_line(_rcx, _rcy, _rcx - cos(_spin) * 12, _rcy + sin(_spin) * 12);
}
// Recording light
draw_set_color((current_time mod 1000 < 500) ? make_color_rgb(230, 40, 40) : make_color_rgb(70, 16, 16));
draw_circle(_bx - 50, _by - 38, 3, false);

// Polygraph box — its needle twitches
draw_set_color(make_color_rgb(52, 54, 58));
draw_rectangle(_bx - 24, _by - 34, _bx + 56, _by, false);
draw_set_color(make_color_rgb(226, 222, 208));
draw_rectangle(_bx - 16, _by - 28, _bx + 48, _by - 8, false);
draw_set_color(make_color_rgb(160, 40, 40));
var _ntw = sin(_t * 7.0) * 6 + sin(_t * 13.7) * 4;
draw_line_width(_bx + 16, _by - 8, _bx + 16 + _ntw, _by - 26, 2);

// The folder — MK-ECHO
draw_set_color(make_color_rgb(180, 158, 110));
draw_rectangle(_bx + 76, _by - 14, _bx + 142, _by, false);
draw_set_color(make_color_rgb(140, 120, 80));
draw_rectangle(_bx + 76, _by - 14, _bx + 142, _by, true);
draw_set_color(make_color_rgb(60, 20, 20));
draw_text_transformed(_bx + 82, _by - 13, "MK-ECHO", 0.55, 0.55, 0);

// ============================================================
// THE HANDLER — standing at the edge of the light (x~1600)
// ============================================================
var _hx = 1600;
var _hy = 420;
// Suit (dark, mostly silhouette)
draw_set_color(make_color_rgb(24, 24, 30));
draw_rectangle(_hx - 24, _hy, _hx + 24, _hy + 180, false);       // legs/coat
draw_rectangle(_hx - 28, _hy - 90, _hx + 28, _hy + 20, false);   // torso
// Head
draw_set_color(make_color_rgb(96, 78, 62));
draw_circle(_hx, _hy - 108, 15, false);
draw_set_color(make_color_rgb(20, 20, 24));
draw_ellipse(_hx - 15, _hy - 124, _hx + 15, _hy - 104, false);   // hair
// Glasses glint
draw_set_color(make_color_rgb(220, 220, 200));
draw_set_alpha(0.6 + 0.3 * sin(_t * 1.3));
draw_line(_hx - 10, _hy - 108, _hx - 2, _hy - 108);
draw_line(_hx + 2,  _hy - 108, _hx + 10, _hy - 108);
draw_set_alpha(1);
// Cigarette — ember pulses in the dark
draw_set_color(make_color_rgb(96, 78, 62));
draw_rectangle(_hx - 44, _hy - 46, _hx - 26, _hy - 38, false);   // raised hand
draw_set_color(make_color_rgb(220, 214, 200));
draw_line_width(_hx - 48, _hy - 44, _hx - 40, _hy - 42, 2);
draw_set_color(make_color_rgb(255, 90, 30));
draw_set_alpha(0.6 + 0.4 * sin(_t * 2.1));
draw_circle(_hx - 49, _hy - 44, 2, false);
draw_set_alpha(1);
// Thin smoke line
draw_set_color(make_color_rgb(140, 140, 140));
draw_set_alpha(0.18);
for (var _sm = 0; _sm < 5; _sm++) {
    var _smy = _hy - 50 - _sm * 16;
    draw_line(_hx - 49 + sin(_t * 1.5 + _sm) * 5, _smy, _hx - 49 + sin(_t * 1.5 + _sm + 0.5) * 5, _smy - 16);
}
draw_set_alpha(1);

// Two of the Handler's men — barely shapes at the edges of the room
draw_set_color(make_color_rgb(16, 16, 20));
draw_rectangle(90, 380, 150, 640, false);
draw_circle(120, 362, 16, false);
draw_rectangle(1790, 380, 1850, 640, false);
draw_circle(1820, 362, 16, false);

// Ambient vignette — the corners of the room fall away
draw_set_color(c_black);
draw_set_alpha(0.35);
draw_rectangle(0, 0, 320, gh, false);
draw_rectangle(gw - 200, 0, gw, gh, false);
draw_rectangle(0, 0, gw, 70, false);
draw_set_alpha(1);

// ============================================================
// PHASE 0: INTRO SLIDES
// ============================================================
if (phase == 0) {
    var _sfa0 = clamp(slide_fade_in / 45.0, 0, 1);

    draw_set_color(c_black);
    draw_set_alpha(0.82);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    // Letterbox lines
    draw_set_color(make_color_rgb(140, 110, 40));
    draw_set_alpha(0.4 * _sfa0);
    draw_rectangle(0, 160, gw, 163, false);
    draw_rectangle(0, gh - 163, gw, gh - 160, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(_sfa0);

    var _m0  = "";
    var _s0  = "";
    var _s0b = "";
    var _m0_col = c_white;

    if (intro_slide == 0) {
        _m0  = "INTERROGATION";
        _m0_col = make_color_rgb(220, 60, 60);
        _s0  = "PROJECT FOXHOLE — SITE 9. No windows. A drain in the floor.";
        _s0b = "They took the hood off under a hot lamp.";
    }
    if (intro_slide == 1) {
        _m0  = "The straps were surgical restraints, not rope.";
        _s0  = "A drip line ran into his left arm. The tape recorder was already turning.";
        _s0b = "Somewhere behind the lamp, a man lit a cigarette.";
    }
    if (intro_slide == 2) {
        _m0  = "\"Veteran ID 44-7821. Danilo.\"";
        _m0_col = make_color_rgb(255, 220, 60);
        _s0  = "\"I'm told you've been remembering things. About the river.\"";
        _s0b = "\"Let's make sure you remember them correctly.\"";
    }
    if (intro_slide == 3) {
        _m0  = "Whatever was in the drip was already working.";
        _s0  = "Dan fixed his eyes on the lamp and dug in.";
        _s0b = "HOLD OUT.";
    }

    draw_set_color(_m0_col);
    draw_text_transformed(gw/2, gh/2 - 50, _m0, 1.6, 1.6, 0);
    draw_set_color(make_color_rgb(160, 148, 90));
    draw_text_transformed(gw/2, gh/2 + 20, _s0, 1.0, 1.0, 0);
    draw_set_color((intro_slide == 3) ? make_color_rgb(220, 60, 60) : make_color_rgb(160, 148, 90));
    draw_text_transformed(gw/2, gh/2 + 58, _s0b, (intro_slide == 3) ? 1.3 : 1.0, (intro_slide == 3) ? 1.3 : 1.0, 0);

    if (slide_fade_in > 30) {
        var _pulse0 = abs(sin(current_time * 0.004)) * 0.6 + 0.3;
        draw_set_color(make_color_rgb(100, 90, 50));
        draw_set_alpha(_pulse0 * _sfa0);
        draw_text_transformed(gw/2, gh - 50, (intro_slide == intro_slides - 1) ? "SPACE to begin" : "SPACE to continue", 0.78, 0.78, 0);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    exit;
}

// ============================================================
// PHASE 1 HUD: resolve meter + round counter
// ============================================================
if (phase == 1) {
    // Resolve meter (top-left)
    var _rw = 340;
    var _rh = 22;
    var _rx = 24;
    var _ry = 18;
    var _rpct = resolve / 100.0;
    draw_set_color(c_black);
    draw_set_alpha(0.55);
    draw_rectangle(_rx - 8, _ry - 8, _rx + _rw + 8, _ry + _rh + 26, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(20, 20, 20));
    draw_rectangle(_rx, _ry, _rx + _rw, _ry + _rh, false);
    var _rcol = make_color_rgb(lerp(220, 60, _rpct), lerp(50, 200, _rpct), 60);
    draw_set_color(_rcol);
    draw_rectangle(_rx, _ry, _rx + _rw * _rpct, _ry + _rh, false);
    draw_set_color(c_white);
    draw_rectangle(_rx, _ry, _rx + _rw, _ry + _rh, true);
    draw_set_color(make_color_rgb(200, 190, 140));
    draw_text_transformed(_rx, _ry + _rh + 4, "RESOLVE", 0.80, 0.80, 0);
    draw_set_color(_rcol);
    draw_text_transformed(_rx + 90, _ry + _rh + 4, string(resolve) + " / 100", 0.80, 0.80, 0);

    // Round counter (top-right)
    draw_set_color(c_black);
    draw_set_alpha(0.55);
    draw_rectangle(gw - 300, 8, gw - 8, 52, false);
    draw_set_alpha(1);
    draw_set_halign(fa_right);
    draw_set_color(make_color_rgb(220, 220, 80));
    draw_text_transformed(gw - 16, 12, "QUESTION " + string(min(ch_index + 1, ch_count)) + " / " + string(ch_count), 1.0, 1.0, 0);
    draw_set_halign(fa_left);

    // Low-resolve pulse at the edges
    if (resolve < 40) {
        var _lva = abs(sin(_t * 3.0)) * 0.16;
        draw_set_color(make_color_rgb(160, 0, 0));
        draw_set_alpha(_lva);
        draw_rectangle(0, 0, gw, 60, false);
        draw_rectangle(0, gh - 60, gw, gh, false);
        draw_set_alpha(1);
    }
    // Resolve hit flash
    if (resolve_flash > 0) {
        draw_set_color(make_color_rgb(180, 0, 0));
        draw_set_alpha((resolve_flash / 45.0) * 0.30);
        draw_rectangle(0, 0, gw, gh, false);
        draw_set_alpha(1);
    }
}

// ============================================================
// PHASE 1 / ch_state 0: THE HANDLER'S QUESTION
// ============================================================
if (phase == 1 && ch_state == 0) {
    draw_set_color(c_black);
    draw_set_alpha(0.72);
    draw_rectangle(gw/2 - 480, gh/2 - 130, gw/2 + 480, gh/2 + 120, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(180, 150, 70));
    draw_rectangle(gw/2 - 480, gh/2 - 130, gw/2 + 480, gh/2 + 120, true);

    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(220, 60, 60));
    draw_text_transformed(gw/2, gh/2 - 110, "THE HANDLER", 1.2, 1.2, 0);
    draw_set_color(c_white);
    draw_text_transformed(gw/2, gh/2 - 40, handler_q[ch_index], 1.05, 1.05, 0);
    draw_set_color(make_color_rgb(160, 148, 90));
    var _ttq = ["Get ready to MASH.", "Get ready to DEFLECT.", "Get ready to HOLD STEADY.", "Get ready to MASH.", "Get ready to DEFLECT."];
    draw_text_transformed(gw/2, gh/2 + 30, _ttq[ch_index], 0.9, 0.9, 0);
    draw_set_color(make_color_rgb(110, 100, 60));
    draw_text_transformed(gw/2, gh/2 + 92, "Starting in " + string(ceil(ch_state_timer / 60)) + "...  (SPACE to face it now)", 0.78, 0.78, 0);
    draw_set_halign(fa_left);
}

// ============================================================
// PHASE 1 / ch_state 1: ACTIVE CHALLENGE
// ============================================================
if (phase == 1 && ch_state == 1) {
    var _type = ch_types[ch_index];

    // Challenge timer bar (top center)
    var _tbw  = 560;
    var _tbh  = 18;
    var _tbx  = gw/2 - _tbw/2;
    var _tby  = 14;
    var _tpct = clamp(ch_timer / ch_time_now, 0, 1);
    draw_set_color(make_color_rgb(20, 20, 20));
    draw_rectangle(_tbx, _tby, _tbx + _tbw, _tby + _tbh, false);
    draw_set_color(make_color_rgb(lerp(220, 60, _tpct), lerp(60, 220, _tpct), 40));
    draw_rectangle(_tbx, _tby, _tbx + _tbw * _tpct, _tby + _tbh, false);
    draw_set_color(c_white);
    draw_rectangle(_tbx, _tby, _tbx + _tbw, _tby + _tbh, true);
    draw_set_halign(fa_center);
    draw_text_transformed(gw/2, _tby, "HOLD OUT", 0.80, 0.80, 0);
    draw_set_halign(fa_left);

    // ---- Type 0: MASH resist ----
    if (_type == 0) {
        draw_set_color(c_black);
        draw_set_alpha(0.75);
        draw_rectangle(gw/2 - 400, gh/2 - 140, gw/2 + 400, gh/2 + 150, false);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(220, 60, 60));
        draw_rectangle(gw/2 - 400, gh/2 - 140, gw/2 + 400, gh/2 + 150, true);

        draw_set_halign(fa_center);
        draw_set_color(make_color_rgb(255, 80, 80));
        draw_text_transformed(gw/2, gh/2 - 120, "RESIST", 1.6, 1.6, 0);
        draw_set_color(c_white);
        draw_text_transformed(gw/2, gh/2 - 66, "MASH  SPACE  (or A)", 1.1, 1.1, 0);
        draw_set_color(make_color_rgb(160, 148, 90));
        draw_text_transformed(gw/2, gh/2 - 32, "The drip is dragging him under. Fill the bar before it empties you.", 0.85, 0.85, 0);

        var _mbw = 560;
        var _mbh = 34;
        var _mbx = gw/2 - _mbw/2;
        var _mby = gh/2 + 10;
        draw_set_color(make_color_rgb(30, 30, 30));
        draw_rectangle(_mbx, _mby, _mbx + _mbw, _mby + _mbh, false);
        draw_set_color(make_color_rgb(220, 180, 40));
        draw_rectangle(_mbx, _mby, _mbx + _mbw * mash_progress, _mby + _mbh, false);
        draw_set_color(c_white);
        draw_rectangle(_mbx, _mby, _mbx + _mbw, _mby + _mbh, true);
        draw_text_transformed(gw/2, _mby + 7, string(floor(mash_progress * 100)) + "%", 0.9, 0.9, 0);

        draw_set_color(make_color_rgb(110, 100, 60));
        draw_text_transformed(gw/2, gh/2 + 116, (ch_index >= 3) ? "The dose is higher this time." : "Don't stop.", 0.80, 0.80, 0);
        draw_set_halign(fa_left);
    }

    // ---- Type 1: HOLD steady (needle) ----
    if (_type == 1) {
        draw_set_color(c_black);
        draw_set_alpha(0.75);
        draw_rectangle(gw/2 - 420, gh/2 - 150, gw/2 + 420, gh/2 + 160, false);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(80, 200, 220));
        draw_rectangle(gw/2 - 420, gh/2 - 150, gw/2 + 420, gh/2 + 160, true);

        draw_set_halign(fa_center);
        draw_set_color(make_color_rgb(120, 220, 240));
        draw_text_transformed(gw/2, gh/2 - 130, "HOLD STEADY", 1.5, 1.5, 0);
        draw_set_color(c_white);
        draw_text_transformed(gw/2, gh/2 - 80, "HOLD  J  (or LB) against the pull — ease off before it swings past", 0.92, 0.92, 0);
        draw_set_color(make_color_rgb(160, 148, 90));
        draw_text_transformed(gw/2, gh/2 - 50, "Keep the polygraph needle in the green.", 0.82, 0.82, 0);

        // Gauge
        var _gww = 560;
        var _gwx = gw/2;
        var _gwy = gh/2 + 12;
        draw_set_color(make_color_rgb(226, 222, 208));
        draw_rectangle(_gwx - _gww/2, _gwy - 24, _gwx + _gww/2, _gwy + 24, false);
        // Green zone
        draw_set_color(make_color_rgb(70, 190, 90));
        draw_set_alpha(0.55);
        draw_rectangle(_gwx - zone_half * (_gww/2), _gwy - 24, _gwx + zone_half * (_gww/2), _gwy + 24, false);
        draw_set_alpha(1);
        // Ticks
        draw_set_color(make_color_rgb(120, 116, 104));
        for (var _tk = -4; _tk <= 4; _tk++) {
            var _tkx = _gwx + _tk * (_gww/8);
            draw_line(_tkx, _gwy + 14, _tkx, _gwy + 24);
        }
        // Needle
        var _npx = _gwx + needle_pos * (_gww/2);
        var _in_zone = (abs(needle_pos) <= zone_half);
        draw_set_color(_in_zone ? make_color_rgb(40, 120, 40) : make_color_rgb(180, 30, 30));
        draw_line_width(_gwx, _gwy + 40, _npx, _gwy - 20, 3);
        draw_circle(_gwx, _gwy + 40, 5, false);
        draw_set_color(c_black);
        draw_rectangle(_gwx - _gww/2, _gwy - 24, _gwx + _gww/2, _gwy + 24, true);

        // Steady-time progress
        var _zpct = clamp(zone_time / zone_need, 0, 1);
        var _zbw  = 420;
        var _zbx  = gw/2 - _zbw/2;
        var _zby  = gh/2 + 78;
        draw_set_color(make_color_rgb(30, 30, 30));
        draw_rectangle(_zbx, _zby, _zbx + _zbw, _zby + 16, false);
        draw_set_color(make_color_rgb(70, 190, 90));
        draw_rectangle(_zbx, _zby, _zbx + _zbw * _zpct, _zby + 16, false);
        draw_set_color(c_white);
        draw_rectangle(_zbx, _zby, _zbx + _zbw, _zby + 16, true);
        draw_set_color(make_color_rgb(110, 100, 60));
        draw_text_transformed(gw/2, _zby + 24, "STEADY  " + string(floor(_zpct * 100)) + "%", 0.80, 0.80, 0);
        draw_set_halign(fa_left);
    }

    // ---- Type 2: DEFLECT prompts ----
    if (_type == 2) {
        draw_set_color(c_black);
        draw_set_alpha(0.75);
        draw_rectangle(gw/2 - 400, gh/2 - 150, gw/2 + 400, gh/2 + 160, false);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(220, 180, 40));
        draw_rectangle(gw/2 - 400, gh/2 - 150, gw/2 + 400, gh/2 + 160, true);

        draw_set_halign(fa_center);
        draw_set_color(make_color_rgb(255, 220, 60));
        draw_text_transformed(gw/2, gh/2 - 130, "DEFLECT", 1.5, 1.5, 0);
        draw_set_color(make_color_rgb(160, 148, 90));
        draw_text_transformed(gw/2, gh/2 - 84, "He's leading you. Turn every question aside — press the way it points.", 0.85, 0.85, 0);

        // Prompt arrow + word
        var _acx = gw/2;
        var _acy = gh/2 + 4;
        var _dirw = (def_current == 0) ? "LEFT!" : "RIGHT!";
        draw_set_color(c_white);
        if (def_current == 0) {
            draw_triangle(_acx - 90, _acy, _acx - 30, _acy - 34, _acx - 30, _acy + 34, false);
            draw_rectangle(_acx - 30, _acy - 14, _acx + 40, _acy + 14, false);
        } else {
            draw_triangle(_acx + 90, _acy, _acx + 30, _acy - 34, _acx + 30, _acy + 34, false);
            draw_rectangle(_acx - 40, _acy - 14, _acx + 30, _acy + 14, false);
        }
        draw_set_color(make_color_rgb(255, 220, 60));
        draw_text_transformed(_acx, _acy - 72, _dirw, 1.5, 1.5, 0);

        // Per-prompt window bar
        var _ppct = clamp(def_prompt_timer / def_window_now, 0, 1);
        var _pbw  = 300;
        var _pbx  = gw/2 - _pbw/2;
        var _pby  = gh/2 + 48;
        draw_set_color(make_color_rgb(30, 30, 30));
        draw_rectangle(_pbx, _pby, _pbx + _pbw, _pby + 10, false);
        draw_set_color(make_color_rgb(lerp(220, 90, _ppct), lerp(60, 200, _ppct), 40));
        draw_rectangle(_pbx, _pby, _pbx + _pbw * _ppct, _pby + 10, false);
        draw_set_color(c_white);
        draw_rectangle(_pbx, _pby, _pbx + _pbw, _pby + 10, true);

        // Tally + misses
        draw_set_color(make_color_rgb(120, 220, 120));
        draw_text_transformed(gw/2 - 130, gh/2 + 76, "DEFLECTED  " + string(def_done) + " / " + string(def_need_now), 0.85, 0.85, 0);
        var _mstr = "";
        for (var _mi = 0; _mi < def_maxmiss; _mi++) {
            _mstr += (_mi < def_miss) ? "X " : "- ";
        }
        draw_set_color(make_color_rgb(220, 90, 90));
        draw_text_transformed(gw/2 + 150, gh/2 + 76, "SLIPS  " + _mstr, 0.85, 0.85, 0);

        draw_set_color(make_color_rgb(110, 100, 60));
        draw_text_transformed(gw/2, gh/2 + 120, "LEFT / RIGHT (or D-pad)  —  wrong way or too slow counts against you", 0.78, 0.78, 0);
        draw_set_halign(fa_left);

        // Hit / miss feedback flash
        if (def_flash != 0) {
            draw_set_color((def_flash > 0) ? make_color_rgb(60, 220, 60) : make_color_rgb(220, 40, 40));
            draw_set_alpha((abs(def_flash) / 18.0) * 0.22);
            draw_rectangle(0, 0, gw, gh, false);
            draw_set_alpha(1);
        }
    }
}

// ============================================================
// PHASE 1 / ch_state 2: RESULT CARD
// ============================================================
if (phase == 1 && ch_state == 2) {
    draw_set_color(c_black);
    draw_set_alpha(0.72);
    draw_rectangle(gw/2 - 360, gh/2 - 90, gw/2 + 360, gh/2 + 90, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    if (ch_result == 1) {
        draw_set_color(make_color_rgb(80, 220, 80));
        draw_text_transformed(gw/2, gh/2 - 24, "HELD OUT", 2.0, 2.0, 0);
        draw_set_color(make_color_rgb(160, 148, 90));
        draw_text_transformed(gw/2, gh/2 + 32, "The Handler's pen stopped moving.", 0.9, 0.9, 0);
    } else {
        draw_set_color(make_color_rgb(220, 60, 60));
        draw_text_transformed(gw/2, gh/2 - 24, "IT SLIPPED", 2.0, 2.0, 0);
        draw_set_color(make_color_rgb(200, 140, 140));
        draw_text_transformed(gw/2, gh/2 + 32, "Words came out of him that he didn't choose.  RESOLVE -25", 0.9, 0.9, 0);
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ============================================================
// PHASE 2: OUTCOME SLIDES (branch on global.interro_resisted)
// ============================================================
if (phase == 2) {
    var _wa = clamp(end_timer / 60.0, 0, 1);

    // Slide 0 — verdict card (first 2.5 s auto, before input unlocks)
    if (narrative_slide == 0) {
        if (global.interro_resisted) {
            draw_set_color(make_color_rgb(8, 30, 8));
        } else {
            draw_set_color(make_color_rgb(30, 8, 8));
        }
        draw_set_alpha(0.90 * _wa);
        draw_rectangle(0, 0, gw, gh, false);
        draw_set_alpha(_wa);

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        if (global.interro_resisted) {
            draw_set_color(make_color_rgb(80, 220, 80));
            draw_text_transformed(gw/2, gh/2 - 60, "HE HELD OUT", 4.0, 4.0, 0);
            draw_set_color(c_white);
            draw_text_transformed(gw/2, gh/2 + 40, "Five questions. Five walls. The recorder clicked off.", 1.1, 1.1, 0);
        } else {
            draw_set_color(make_color_rgb(220, 60, 60));
            draw_text_transformed(gw/2, gh/2 - 60, "HE BROKE", 4.0, 4.0, 0);
            draw_set_color(c_white);
            draw_text_transformed(gw/2, gh/2 + 40, "Somewhere in the fourth hour, Dan heard his own voice say things he couldn't take back.", 1.05, 1.05, 0);
        }
        if (end_timer > 150) {
            draw_set_color(make_color_rgb(110, 100, 60));
            draw_text_transformed(gw/2, gh/2 + 100, "SPACE to continue   |   R to restart the interrogation", 0.80, 0.80, 0);
        }
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_alpha(1);
        exit;
    }

    // Fade alpha per slide (0→1 over 45 frames)
    var _sfa = clamp(slide_fade_in / 45.0, 0, 1);

    // Deep black for all narrative slides
    draw_set_color(c_black);
    draw_set_alpha(0.92);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    // Letterbox lines
    draw_set_color(make_color_rgb(140, 110, 40));
    draw_set_alpha(0.4 * _sfa);
    draw_rectangle(0, 160, gw, 163, false);
    draw_rectangle(0, gh - 163, gw, gh - 160, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(_sfa);

    var _main = "";
    var _sub  = "";
    var _sub2 = "";
    var _main_col = c_white;
    var _sub_col  = make_color_rgb(160, 148, 90);

    if (global.interro_resisted) {
        // === RESISTED branch — Dan learns the truth cleanly ===
        if (narrative_slide == 1) {
            _main = "The Handler stubbed out his cigarette.";
            _sub  = "\"Remarkable,\" he said, to no one in the room.";
            _sub2 = "\"The conditioning held better than the design spec.\"";
        }
        if (narrative_slide == 2) {
            _main = "\"You want the truth about the river, Private? You've earned this much.\"";
            _main_col = make_color_rgb(255, 220, 60);
            _sub  = "He slid the folder across the table. MK-ECHO.";
            _sub2 = "Dan's own name on the first page inside.";
        }
        if (narrative_slide == 3) {
            _main = "\"Project FOXHOLE didn't study your trauma, Dan.\"";
            _main_col = make_color_rgb(220, 80, 80);
            _sub  = "\"It built on it. You were the foundation.\"";
            _sub2 = "Veteran ID 44-7821. Test subject one.";
        }
        if (narrative_slide == 4) {
            _main = "The nightmares weren't memories leaking out.";
            _sub  = "They were programming settling in.";
            _sub2 = "Fifteen years of letters signed \"H\", tightening like a knot Hayes taught him.";
            _sub_col = make_color_rgb(200, 140, 140);
        }
        if (narrative_slide == 5) {
            _main = "\"Harrington will want to see you himself,\" the Handler said.";
            _sub  = "He nodded at the men behind the lamp.";
            _sub2 = "\"Bring the chair.\"";
        }
    } else {
        // === BROKEN branch — the unreliable version ===
        if (narrative_slide == 1) {
            _main = "When it was over, the Handler was smiling.";
            _sub  = "\"There,\" he said. \"That wasn't so hard.\"";
            _sub2 = "The reels kept turning long after Dan stopped talking.";
        }
        if (narrative_slide == 2) {
            _main = "Dan couldn't remember what he'd told them.";
            _main_col = make_color_rgb(220, 80, 80);
            _sub  = "That was the worst part.";
            _sub2 = "The hole where the last hour should have been.";
        }
        if (narrative_slide == 3) {
            _main = "Fragments floated back wrong.";
            _sub  = "The river running backwards. Hayes' voice coming off the tape recorder.";
            _sub2 = "Which parts had he said? Which parts had they put in?";
            _sub_col = make_color_rgb(200, 140, 140);
        }
        if (narrative_slide == 4) {
            _main = "\"Project FOXHOLE thanks you for your continued participation.\"";
            _main_col = make_color_rgb(255, 220, 60);
            _sub  = "The Handler read it flat, off the folder. MK-ECHO.";
            _sub2 = "\"Subject 44-7821. Baseline restored.\"";
        }
        if (narrative_slide == 5) {
            _main = "\"Harrington will want to see you himself,\" the Handler said.";
            _sub  = "He nodded at the men behind the lamp.";
            _sub2 = "\"Bring the chair.\"";
        }
    }

    if (narrative_slide == 6) {
        _main = "They wheeled in something with wires.";
        _main_col = make_color_rgb(220, 60, 60);
        _sub  = "THE CHAIR";
        _sub2 = "";
        _sub_col = make_color_rgb(255, 80, 80);
        var _ret_a = clamp((slide_fade_in - 120) / 60.0, 0, 1);
        draw_set_color(make_color_rgb(80, 70, 40));
        draw_set_alpha(_ret_a * _sfa);
        draw_text_transformed(gw/2, gh/2 + 110, "...", 1.2, 1.2, 0);
        draw_set_alpha(_sfa);
    }

    draw_set_color(_main_col);
    draw_text_transformed(gw/2, gh/2 - 50, _main, 1.6, 1.6, 0);
    draw_set_color(_sub_col);
    draw_text_transformed(gw/2, gh/2 + 20, _sub, (narrative_slide == 6) ? 2.0 : 1.0, (narrative_slide == 6) ? 2.0 : 1.0, 0);
    draw_text_transformed(gw/2, gh/2 + 58, _sub2, 1.0, 1.0, 0);

    // Prompt (not on final slide)
    if (narrative_slide < outcome_slides - 1 && slide_fade_in > 60) {
        var _pulse = abs(sin(current_time * 0.004)) * 0.6 + 0.3;
        draw_set_color(make_color_rgb(100, 90, 50));
        draw_set_alpha(_pulse * _sfa);
        draw_text_transformed(gw/2, gh - 50, "SPACE to continue   |   R to restart", 0.78, 0.78, 0);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
}

// Score (top-right during outcome, matches obj_controller4 style)
if (phase == 2) {
    draw_set_color(c_black);
    draw_set_alpha(0.55);
    draw_rectangle(gw - 280, 8, gw - 8, 50, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(220, 220, 80));
    draw_set_halign(fa_right);
    draw_text_transformed(gw - 16, 12, "SCORE  " + string(global.score), 1.0, 1.0, 0);
    draw_set_halign(fa_left);
}
draw_set_color(c_white);
