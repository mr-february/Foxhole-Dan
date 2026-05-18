var gw  = display_get_gui_width();
var gh  = display_get_gui_height();
var lb  = 82;
var cay = lb;
var cab = gh - lb;
var cah = cab - cay;
var mid = gw * 0.5;

// ─────────────────────────────────────────────────────────────
// BLACK BASE
// ─────────────────────────────────────────────────────────────
draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);

// ─────────────────────────────────────────────────────────────
// PANEL CONTENT
// ─────────────────────────────────────────────────────────────
var gy = cab - 16;

switch (panel) {

// ───────────────────────────────────────────────────────────
case 0: // AFTERMATH — Dan's jeep outside, explosion behind him
// ───────────────────────────────────────────────────────────
    // Night sky gradient
    for (var si = 0; si < 10; si++) {
        var t = si / 10.0;
        draw_set_color(make_color_rgb(
            round(lerp(4,  18, t)),
            round(lerp(8,  28, t)),
            round(lerp(18, 52, t))
        ));
        draw_rectangle(0, cay + t * cah, gw, cay + (t + 0.1) * cah, false);
    }
    // Stars
    draw_set_color(make_color_rgb(200, 200, 210));
    for (var st = 0; st < 40; st++) {
        var stx = (st * 487) mod gw;
        var sty = cay + (st * 311) mod (cah * 0.55);
        var sta = 0.4 + sin(current_time * 0.01 + st) * 0.3;
        draw_set_alpha(sta);
        draw_circle(stx, sty, 1, false);
    }
    draw_set_alpha(1);
    // Distant skyline silhouette (Brooklyn)
    draw_set_color(make_color_rgb(12, 10, 18));
    for (var sk = 0; sk < 18; sk++) {
        var bx  = sk * 110 + 20;
        var bh2 = 30 + (sk * 53) mod 60;
        var bw2 = 50 + (sk * 31) mod 40;
        draw_rectangle(bx, gy - bh2, bx + bw2, gy, false);
        // Window lights
        draw_set_color(make_color_rgb(220, 200, 140));
        for (var wn = 0; wn < 3; wn++) {
            if ((sk + wn) mod 3 != 0) {
                draw_rectangle(bx + 8 + wn * 14, gy - bh2 + 8 + (sk mod 3) * 12,
                               bx + 18 + wn * 14, gy - bh2 + 18 + (sk mod 3) * 12, false);
            }
        }
        draw_set_color(make_color_rgb(12, 10, 18));
    }
    // Explosion glow (right side — the depot)
    var eg = 0.55 + abs(sin(current_time * 0.028)) * 0.3;
    draw_set_alpha(eg);
    draw_set_color(make_color_rgb(230, 95, 18));
    draw_ellipse(gw - 200, cay + cah * 0.4, gw + 120, gy, false);
    draw_set_alpha(eg * 0.5);
    draw_set_color(make_color_rgb(255, 200, 60));
    draw_ellipse(gw - 160, cay + cah * 0.5, gw + 60, gy, false);
    draw_set_alpha(1);
    // Orange sky glow from explosion
    draw_set_alpha(0.22 + abs(sin(current_time * 0.025)) * 0.12);
    draw_set_color(make_color_rgb(200, 70, 10));
    draw_rectangle(gw * 0.55, cay, gw, cay + cah * 0.6, false);
    draw_set_alpha(1);
    // Ground / road
    draw_set_color(make_color_rgb(18, 14, 10));
    draw_rectangle(0, gy - 30, gw, gy, false);
    draw_set_color(make_color_rgb(28, 22, 16));
    draw_rectangle(0, gy - 32, gw, gy - 28, false);
    // Dan's jeep silhouette (simplified, center-left)
    var jx = mid - 320;
    var jy = gy;
    draw_set_color(make_color_rgb(38, 50, 28));
    draw_rectangle(jx - 42, jy - 24, jx + 42, jy - 6, false);  // chassis
    draw_rectangle(jx - 4,  jy - 36, jx + 30, jy - 24, false); // cab
    draw_rectangle(jx + 26, jy - 20, jx + 52, jy - 8,  false); // hood
    draw_set_color(make_color_rgb(22, 18, 12));
    draw_circle(jx - 24, jy, 12, false);
    draw_circle(jx + 24, jy, 12, false);
    // Location card
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(190, 170, 130));
    draw_text_transformed(mid, cay + cah * 0.12, "BROOKLYN WATERFRONT", 1.4, 1.4, 0);
    draw_set_color(make_color_rgb(140, 120, 90));
    draw_text_transformed(mid, cay + cah * 0.24, "0247 HRS", 1.1, 1.1, 0);
    // Narration strip
    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(6, 4, 2));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, false);
    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(180, 140, 50));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, true);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(200, 178, 118));
    draw_text_transformed(mid, cab - 78, "You made it out.", 1.05, 1.05, 0);
    draw_text_transformed(mid, cab - 52, "The depot is gone.", 1.05, 1.05, 0);
    draw_set_halign(fa_left);
    break;

// ───────────────────────────────────────────────────────────
case 1: // THE DOCUMENT — Dan reads the clue in the jeep
// ───────────────────────────────────────────────────────────
    // Dark jeep interior — dim orange glow from dashboard
    draw_set_color(make_color_rgb(14, 10, 6));
    draw_rectangle(0, cay, gw, cab, false);
    draw_set_alpha(0.35);
    draw_set_color(make_color_rgb(180, 80, 15));
    draw_ellipse(0, cay + cah * 0.5, 280, cab, false);
    draw_set_alpha(1);
    // Dashboard (bottom strip)
    draw_set_color(make_color_rgb(28, 20, 14));
    draw_rectangle(0, cab - 55, gw, cab, false);
    draw_set_color(make_color_rgb(38, 28, 18));
    draw_rectangle(0, cab - 58, gw, cab - 54, false);
    // Gauges
    draw_set_color(make_color_rgb(60, 45, 28));
    draw_circle(180, cab - 32, 18, false);
    draw_circle(260, cab - 32, 14, false);
    draw_set_color(make_color_rgb(200, 160, 80));
    draw_circle(180, cab - 32, 18, true);
    // Document held up — center of frame
    var _dx  = mid - 260;
    var _dw  = 520;
    var _dy  = cay + cah * 0.06;
    var _dh  = cah * 0.72;
    // Slight rotation for held-in-hand feel
    // Shadow
    draw_set_color(make_color_rgb(8, 5, 3));
    draw_rectangle(_dx + 10, _dy + 10, _dx + _dw + 10, _dy + _dh + 10, false);
    // Paper
    draw_set_color(make_color_rgb(215, 202, 172));
    draw_rectangle(_dx, _dy, _dx + _dw, _dy + _dh, false);
    // Burn corner top-right
    draw_set_color(make_color_rgb(70, 44, 16));
    draw_ellipse(_dx + _dw - 45, _dy - 18, _dx + _dw + 18, _dy + 50, false);
    // Paper content
    draw_set_color(make_color_rgb(22, 14, 8));
    draw_set_halign(fa_center);
    draw_text_transformed(mid, _dy + 12, "OPERATION ARDENNES ECHO", 0.8, 0.8, 0);
    draw_text_transformed(mid, _dy + 28, "CLASSIFICATION: ULTRA — EYES ONLY", 0.7, 0.7, 0);
    draw_rectangle(_dx + 16, _dy + 44, _dx + _dw - 16, _dy + 46, false);
    draw_text_transformed(mid, _dy + 58,  "HARRINGTON BUILDING", 1.55, 1.55, 0);
    draw_text_transformed(mid, _dy + 88,  "52nd Floor — Manhattan", 1.0,  1.0,  0);
    draw_rectangle(_dx + 16, _dy + 108, _dx + _dw - 16, _dy + 110, false);
    draw_text_transformed(mid, _dy + 122, "Contact:  H", 1.25, 1.25, 0);
    draw_text_transformed(mid, _dy + 150, "Authorization:  [ REDACTED ]", 0.85, 0.85, 0);
    draw_rectangle(_dx + 16, _dy + 170, _dx + _dw - 16, _dy + 172, false);
    draw_text_transformed(mid, _dy + 185, "Midnight.  Come alone.", 1.0,  1.0,  0);
    draw_set_halign(fa_left);
    // Narration
    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(6, 4, 2));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, false);
    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(180, 140, 50));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, true);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(200, 178, 118));
    draw_set_halign(fa_center);
    draw_text_transformed(mid, cab - 78, "They left a trail.  On purpose.", 1.0, 1.0, 0);
    draw_text_transformed(mid, cab - 52, "H wanted to be found.", 1.0, 1.0, 0);
    draw_set_halign(fa_left);
    break;

// ───────────────────────────────────────────────────────────
case 2: // WHO IS H — implications, no name given
// ───────────────────────────────────────────────────────────
    // Near-black with subtle blue cast — cold, cerebral
    draw_set_color(make_color_rgb(8, 10, 18));
    draw_rectangle(0, cay, gw, cab, false);
    // Classified document fragments floating in frame
    var _frags = [
        "OPERATION: ARDENNES ECHO",
        "PHASE 3 — PSYCHOLOGICAL DISMANTLEMENT",
        "TARGET:  SUBJECT DAN  [ VETERAN ID 44-7821 ]",
        "METHOD:  MEMORY INDUCTION / SLEEP DISRUPTION",
        "LETTERS SCHEDULE:  SEE ATTACHMENT H-7",
        "AUTHORIZATION:  [ REDACTED ]",
        "HANDLER:  H",
    ];
    for (var _fr = 0; _fr < array_length(_frags); _fr++) {
        var _fy   = cay + cah * 0.10 + _fr * (cah * 0.11);
        var _fade = 0.25 + 0.65 * (_fr / (array_length(_frags) - 1));
        draw_set_alpha(_fade);
        if (_fr == array_length(_frags) - 1) {
            draw_set_color(make_color_rgb(220, 80, 60));
        } else {
            draw_set_color(make_color_rgb(155, 135, 100));
        }
        draw_set_halign(fa_center);
        draw_text_transformed(mid, _fy, _frags[_fr], 0.88, 0.88, 0);
    }
    draw_set_alpha(1);
    draw_rectangle(mid - 220, cay + cah * 0.10 + 3 * cah * 0.11 - 2,
                   mid + 220, cay + cah * 0.10 + 3 * cah * 0.11, false);
    draw_set_halign(fa_left);
    // Narration
    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(6, 4, 2));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, false);
    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(180, 140, 50));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, true);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(200, 178, 118));
    draw_set_halign(fa_center);
    draw_text_transformed(mid, cab - 78, "Your nightmares didn't come from the war.", 1.0, 1.0, 0);
    draw_text_transformed(mid, cab - 52, "Someone built them.  Someone with a plan.", 1.0, 1.0, 0);
    draw_set_halign(fa_left);
    break;

// ───────────────────────────────────────────────────────────
case 3: // THE TOWER — Manhattan skyline, Harrington Tower
// ───────────────────────────────────────────────────────────
    // Deep night sky
    for (var _si = 0; _si < 8; _si++) {
        var _t = _si / 8.0;
        draw_set_color(make_color_rgb(
            round(lerp(2,  14, _t)),
            round(lerp(5,  20, _t)),
            round(lerp(14, 42, _t))
        ));
        draw_rectangle(0, cay + _t * cah, gw, cay + (_t + 0.13) * cah, false);
    }
    // Stars
    draw_set_color(make_color_rgb(210, 215, 225));
    for (var _st = 0; _st < 55; _st++) {
        draw_set_alpha(0.35 + sin(current_time * 0.008 + _st) * 0.25);
        var _stx = (_st * 367) mod gw;
        var _sty = cay + (_st * 213) mod (cah * 0.45);
        draw_circle(_stx, _sty, 1 + (_st mod 3 == 0 ? 1 : 0), false);
    }
    draw_set_alpha(1);
    // Rain (diagonal lines)
    draw_set_alpha(0.18);
    draw_set_color(make_color_rgb(140, 160, 200));
    for (var _r = 0; _r < 30; _r++) {
        var _rx = (_r * 65 + current_time mod 65) mod gw;
        var _ry = cay + (_r * 89) mod cah;
        draw_line(_rx, _ry, _rx - 10, _ry + 28);
    }
    draw_set_alpha(1);
    // Manhattan skyline — varied building heights
    var _skyH = [90, 70, 110, 85, 65, 95, 80, 75, 105, 60, 88, 72, 92, 68, 78, 84, 98, 66];
    var _skyW = [70, 55, 65, 58, 50, 62, 56, 52, 60, 48, 64, 54, 68, 50, 58, 62, 70, 52];
    var _skyX = 0;
    for (var _sk = 0; _sk < array_length(_skyH); _sk++) {
        draw_set_color(make_color_rgb(14, 14, 22));
        draw_rectangle(_skyX, gy - _skyH[_sk], _skyX + _skyW[_sk], gy, false);
        // Window grid
        draw_set_color(make_color_rgb(200, 185, 120));
        for (var _wy = 0; _wy < _skyH[_sk] - 10; _wy += 14) {
            for (var _wx = 0; _wx < _skyW[_sk] - 8; _wx += 12) {
                if ((_sk + _wy + _wx) mod 5 != 0) {
                    draw_set_alpha(0.35 + sin(_sk * 0.8 + _wy * 0.3) * 0.2);
                    draw_rectangle(_skyX + _wx + 4, gy - _skyH[_sk] + _wy + 4,
                                   _skyX + _wx + 10, gy - _skyH[_sk] + _wy + 10, false);
                }
            }
        }
        _skyX += _skyW[_sk] + 6;
    }
    draw_set_alpha(1);
    // HARRINGTON TOWER — taller than everything, lit at top (center)
    var _tx  = mid - 50;
    var _tw  = 100;
    var _th  = 260;
    draw_set_color(make_color_rgb(10, 10, 18));
    draw_rectangle(_tx, gy - _th, _tx + _tw, gy, false);
    // Tower windows — mostly dark
    draw_set_color(make_color_rgb(188, 172, 108));
    for (var _twy = 0; _twy < _th - 10; _twy += 14) {
        for (var _twx = 0; _twx < _tw - 8; _twx += 14) {
            if ((_twy + _twx) mod 3 == 0) {
                draw_set_alpha(0.25);
                draw_rectangle(_tx + _twx + 4, gy - _th + _twy + 4,
                               _tx + _twx + 10, gy - _th + _twy + 10, false);
            }
        }
    }
    draw_set_alpha(1);
    // Top floor — ONE window blazing (the lit room)
    draw_set_alpha(0.9 + sin(current_time * 0.015) * 0.08);
    draw_set_color(make_color_rgb(255, 220, 110));
    draw_rectangle(_tx + 8, gy - _th + 6, _tx + _tw - 8, gy - _th + 26, false);
    draw_set_alpha(0.35);
    draw_set_color(make_color_rgb(255, 200, 80));
    draw_ellipse(_tx - 20, gy - _th - 10, _tx + _tw + 20, gy - _th + 50, false);
    draw_set_alpha(1);
    // Tower label
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(160, 140, 100));
    draw_text_transformed(mid, gy - _th - 28, "HARRINGTON TOWER", 0.95, 0.95, 0);
    draw_set_color(make_color_rgb(110, 98, 70));
    draw_text_transformed(mid, gy - _th - 14, "52nd Floor", 0.82, 0.82, 0);
    // Narration
    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(6, 4, 2));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, false);
    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(180, 140, 50));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, true);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(200, 178, 118));
    draw_text_transformed(mid, cab - 78, "One light on.  Top floor.", 1.0, 1.0, 0);
    draw_text_transformed(mid, cab - 52, "H was already expecting you.", 1.0, 1.0, 0);
    draw_set_halign(fa_left);
    break;

// ───────────────────────────────────────────────────────────
case 4: // DAN'S RESOLVE
// ───────────────────────────────────────────────────────────
    // Night, wet road — driving toward Manhattan
    draw_set_color(make_color_rgb(10, 12, 20));
    draw_rectangle(0, cay, gw, cab, false);
    // Road ahead (perspective lines)
    draw_set_color(make_color_rgb(22, 18, 14));
    draw_rectangle(0, gy - 35, gw, gy, false);
    draw_set_color(make_color_rgb(30, 24, 18));
    draw_rectangle(0, gy - 37, gw, gy - 33, false);
    // Road center dashes
    draw_set_color(make_color_rgb(140, 120, 80));
    for (var _d = 0; _d < 12; _d++) {
        var _doff = (current_time * 3) mod 140;
        draw_rectangle((_d * 140 - _doff) mod gw, gy - 20,
                       (_d * 140 - _doff) mod gw + 60, gy - 16, false);
    }
    // City glow on horizon
    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(80, 60, 30));
    draw_ellipse(mid - 400, cay + cah * 0.55, mid + 400, gy + 30, false);
    draw_set_alpha(1);
    // Rain
    draw_set_alpha(0.2);
    draw_set_color(make_color_rgb(130, 150, 190));
    for (var _rv = 0; _rv < 25; _rv++) {
        var _rox = (_rv * 78 + current_time * 2) mod gw;
        var _roy = cay + (_rv * 97) mod cah;
        draw_line(_rox, _roy, _rox - 8, _roy + 24);
    }
    draw_set_alpha(1);
    // Dan silhouette in driver seat
    var _sx = 520;
    var _sy = gy - 4;
    draw_set_color(make_color_rgb(42, 55, 30));   // torso
    draw_rectangle(_sx - 14, _sy - 36, _sx + 14, _sy - 16, false);
    draw_set_color(make_color_rgb(185, 130, 80));  // face
    draw_rectangle(_sx - 8,  _sy - 50, _sx + 8,  _sy - 36, false);
    draw_set_color(make_color_rgb(48, 62, 28));    // helmet
    draw_rectangle(_sx - 12, _sy - 58, _sx + 12, _sy - 46, false);
    draw_rectangle(_sx - 14, _sy - 47, _sx + 14, _sy - 46, false);
    // Dialogue box
    var _bx1 = 70;
    var _by1 = cab - 138;
    var _bx2 = gw - 70;
    var _by2 = cab - 8;
    draw_set_alpha(0.82);
    draw_set_color(make_color_rgb(6, 5, 3));
    draw_rectangle(_bx1, _by1, _bx2, _by2, false);
    draw_set_alpha(0.55);
    draw_set_color(make_color_rgb(80, 160, 80));
    draw_rectangle(_bx1, _by1, _bx2, _by2, true);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(100, 180, 100));
    draw_set_halign(fa_left);
    draw_text_transformed(_bx1 + 16, _by1 + 8, "DAN:", 1.05, 1.05, 0);
    draw_set_color(c_white);
    draw_text_transformed(_bx1 + 16, _by1 + 30, "You wanted me to come.  Fine.", 0.95, 0.95, 0);
    draw_text_transformed(_bx1 + 16, _by1 + 52, "I don't know who you are.", 0.95, 0.95, 0);
    draw_text_transformed(_bx1 + 16, _by1 + 74, "But I'm going to find out.", 0.95, 0.95, 0);
    break;

// ───────────────────────────────────────────────────────────
case 5: // TITLE CARD — Level 3 tease
// ───────────────────────────────────────────────────────────
    // Pure black with faint tower silhouette
    draw_set_alpha(0.06);
    // Tall building center
    draw_set_color(make_color_rgb(80, 80, 120));
    draw_rectangle(mid - 55, cay, mid + 55, cab, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    var _ty  = cay + cah * 0.08;
    var _gap = 52;

    draw_set_color(make_color_rgb(100, 95, 70));
    draw_text_transformed(mid, _ty, "LEVEL  3", 2.2, 2.2, 0);

    draw_set_color(make_color_rgb(205, 185, 110));
    draw_text_transformed(mid, _ty + _gap * 1.2, "THE HARRINGTON TOWER", 1.6, 1.6, 0);

    draw_set_color(make_color_rgb(80, 75, 55));
    draw_rectangle(mid - 200, _ty + _gap * 2.1, mid + 200, _ty + _gap * 2.1 + 2, false);

    draw_set_color(make_color_rgb(140, 120, 80));
    draw_text_transformed(mid, _ty + _gap * 2.5, "52 floors between Dan and the truth.", 1.0, 1.0, 0);

    draw_set_color(make_color_rgb(100, 88, 60));
    draw_text_transformed(mid, _ty + _gap * 3.3, "H is waiting at the top.", 1.0, 1.0, 0);

    draw_set_color(make_color_rgb(80, 75, 55));
    draw_rectangle(mid - 200, _ty + _gap * 4.1, mid + 200, _ty + _gap * 4.1 + 2, false);

    draw_set_color(make_color_rgb(180, 50, 50));
    draw_text_transformed(mid, _ty + _gap * 4.6, "Dan has climbed worse.", 1.2, 1.2, 0);

    draw_set_halign(fa_left);
    break;

// ───────────────────────────────────────────────────────────
case 6: // DAN EXITS THE VEHICLE — on foot at the building base
// ───────────────────────────────────────────────────────────
    // Night street-level view: tower looms left, jeep parked right
    draw_set_color(make_color_rgb(8, 10, 18));
    draw_rectangle(0, cay, gw, cab, false);
    // Rain
    draw_set_alpha(0.18);
    draw_set_color(make_color_rgb(130, 150, 200));
    for (var _r3 = 0; _r3 < 28; _r3++) {
        var _rx3 = (_r3 * 71 + current_time * 2) mod gw;
        var _ry3 = cay + (_r3 * 83) mod cah;
        draw_line(_rx3, _ry3, _rx3 - 8, _ry3 + 24);
    }
    draw_set_alpha(1);
    // Ground / wet road
    draw_set_color(make_color_rgb(16, 12, 8));
    draw_rectangle(0, gy - 30, gw, gy, false);
    draw_set_color(make_color_rgb(24, 20, 14));
    draw_rectangle(0, gy - 32, gw, gy - 28, false);
    // Harrington Tower base (center-left, from street level — looming)
    var _tb = mid - 260;
    var _tw2 = 200;
    draw_set_color(make_color_rgb(10, 10, 18));
    draw_rectangle(_tb, cay, _tb + _tw2, gy, false);
    // Tower window grid — mostly dark
    draw_set_color(make_color_rgb(180, 165, 95));
    for (var _twy2 = 10; _twy2 < cah - 20; _twy2 += 18) {
        for (var _twx2 = 8; _twx2 < _tw2 - 8; _twx2 += 16) {
            if ((_twy2 + _twx2) mod 5 != 0) {
                draw_set_alpha(0.14);
                draw_rectangle(_tb + _twx2, cay + _twy2, _tb + _twx2 + 10, cay + _twy2 + 8, false);
            }
        }
    }
    draw_set_alpha(1);
    // 52nd floor — one blazing window at top
    draw_set_alpha(0.88 + sin(current_time * 0.015) * 0.08);
    draw_set_color(make_color_rgb(255, 220, 100));
    draw_rectangle(_tb + 10, cay + 6, _tb + _tw2 - 10, cay + 26, false);
    draw_set_alpha(0.28);
    draw_set_color(make_color_rgb(255, 200, 70));
    draw_ellipse(_tb - 20, cay - 12, _tb + _tw2 + 20, cay + 55, false);
    draw_set_alpha(1);
    // Building entrance — double doors
    draw_set_color(make_color_rgb(28, 20, 12));
    draw_rectangle(_tb + 70, gy - 60, _tb + 130, gy - 2, false);
    draw_set_color(make_color_rgb(48, 36, 20));
    draw_rectangle(_tb + 72, gy - 58, _tb + 96,  gy - 4, false);
    draw_rectangle(_tb + 100, gy - 58, _tb + 128, gy - 4, false);
    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(170, 150, 80));
    draw_rectangle(_tb + 96, gy - 58, _tb + 102, gy - 4, false);
    draw_set_alpha(1);
    // Jeep parked right — engine off
    var _jx2 = mid + 240;
    var _jy2 = gy;
    draw_set_color(make_color_rgb(34, 46, 24));
    draw_rectangle(_jx2 - 44, _jy2 - 24, _jx2 + 44, _jy2 - 6, false);
    draw_rectangle(_jx2 - 6,  _jy2 - 37, _jx2 + 30, _jy2 - 24, false);
    draw_rectangle(_jx2 + 26, _jy2 - 21, _jx2 + 54, _jy2 - 8,  false);
    draw_set_color(make_color_rgb(20, 16, 10));
    draw_circle(_jx2 - 24, _jy2, 12, false);
    draw_circle(_jx2 + 24, _jy2, 12, false);
    // Dan silhouette — on foot, facing the building, kit in hand
    var _ds = mid + 80;
    var _dsy = gy;
    draw_set_color(make_color_rgb(40, 52, 28));  // torso
    draw_rectangle(_ds - 13, _dsy - 44, _ds + 13, _dsy - 18, false);
    draw_set_color(make_color_rgb(185, 128, 76)); // face
    draw_rectangle(_ds - 7, _dsy - 58, _ds + 7, _dsy - 44, false);
    draw_set_color(make_color_rgb(46, 60, 26));  // helmet
    draw_rectangle(_ds - 11, _dsy - 66, _ds + 11, _dsy - 54, false);
    draw_rectangle(_ds - 13, _dsy - 55, _ds + 13, _dsy - 54, false);
    // Rifle slung over shoulder
    draw_set_color(make_color_rgb(50, 38, 24));
    draw_rectangle(_ds + 8, _dsy - 66, _ds + 12, _dsy - 26, false);
    // Narration strip
    draw_set_alpha(0.82);
    draw_set_color(make_color_rgb(6, 4, 2));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, false);
    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(180, 140, 50));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, true);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(200, 178, 118));
    draw_set_halign(fa_center);
    draw_text_transformed(mid, cab - 78, "Dan killed the engine.  Grabbed his kit.", 1.0, 1.0, 0);
    draw_text_transformed(mid, cab - 52, "The elevator wasn't an option.", 1.0, 1.0, 0);
    draw_set_halign(fa_left);
    break;

} // end switch

// ─────────────────────────────────────────────────────────────
// LETTERBOX BARS
// ─────────────────────────────────────────────────────────────
draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, lb, false);
draw_rectangle(0, gh - lb, gw, gh, false);

// ─────────────────────────────────────────────────────────────
// CONTINUE PROMPT
// ─────────────────────────────────────────────────────────────
if (fade <= 5) {
    var pa = 0.45 + sin(current_time * 0.008) * 0.3;
    draw_set_alpha(pa);
    draw_set_color(make_color_rgb(190, 165, 90));
    draw_set_halign(fa_center);
    draw_text_transformed(mid, gh - lb + 22, "SPACE / A  to continue", 0.88, 0.88, 0);
    draw_set_halign(fa_left);
    draw_set_alpha(1);
}

// ─────────────────────────────────────────────────────────────
// PANEL LABEL
// ─────────────────────────────────────────────────────────────
draw_set_color(make_color_rgb(80, 65, 38));
draw_set_halign(fa_right);
draw_text_transformed(gw - 24, 22, string(panel + 1) + " / " + string(panels), 0.82, 0.82, 0);
draw_set_halign(fa_left);

// ─────────────────────────────────────────────────────────────
// FADE OVERLAY
// ─────────────────────────────────────────────────────────────
if (fade > 0) {
    draw_set_alpha(fade / 60.0);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
